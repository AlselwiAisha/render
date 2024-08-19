class V1::Users::RegistrationsController < Devise::RegistrationsController
  skip_before_action :authenticate_scope!, only: %i[create update]

  include RackSessionsFix

  respond_to :json

  def update
      filtered_params = filter_params
    if user_params[:current_password].present?
      successfully_updated = {
        action_errors: current_user.update_with_password(filtered_params),
        attempt: 'Tried to update all',
        message: "Updated info are #{updated_columns_message(filtered_params)}"
      }
    else
      current_user.update(filter_params.except(:current_password, :password, :password_confirmation, :email))
      successfully_updated = {
        action_errors: current_user.errors.blank?,
        attempt: 'Tried to update some',
        message: "Updated info are #{updated_columns_message(filtered_params)} since current password is not provided or password and password confirmation do not match"
      }
    end

    if successfully_updated[:action_errors]
      bypass_sign_in(current_user)
      render json: {
        message: 'Successfully updated.',
        attempt: successfully_updated[:attempt],
        details: successfully_updated[:message]
      }, status: :ok
    else
      render json: {
        message: 'Update failed.',
        attempt: successfully_updated[:attempt],
        details: successfully_updated[:message]
      }, status: :unprocessable_entity
    end
  end

  private

  def filter_params
    params_required = %i[name address phone]
    if user_params[:current_password].present?
      params_required += %i[email password password_confirmation current_password] if valid_passwords?(user_params[:current_password], user_params[:password], user_params[:password_confirmation])
    end
    user_params.permit(params_required)
  end

  def resource_name
    :user
  end

  def respond_with(resource, _opts = {})
    if resource.persisted?
      if action_name == 'create'
        render json: {
          status: { code: 200, message: 'Signed up successfully.' },
          data: { name: resource.name, email: resource.email, created_at: resource.created_at, updated_at: resource.updated_at }
        }, status: :ok
      elsif action_name == 'update'
        render json: {
          status: { code: 200, message: 'Updated successfully.' },
          data: { name: resource.name, email: resource.email, updated_at: resource.updated_at }
        }, status: :ok
      end
    else
      if action_name == 'create'
        render json: {
          message: "User couldn't be created successfully. #{resource.errors.full_messages.to_sentence}",
          status: :unprocessable_entity
        }
      elsif action_name == 'update'
        render json: {
          message: "User couldn't be updated successfully. #{resource.errors.full_messages.to_sentence}",
          status: :unprocessable_entity
        }
      end
    end
  end

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :current_password, :address, :phone)
  end

  protected

  def updated_columns_message(filter_params)
    updated_columns = filter_params.keys.map(&:to_s)
    updated_columns.reject { |key| key == 'password_confirmation' }.map { |key| key.tr('_', ' ') }
  end

  def valid_passwords?(current_password, password, password_confirmation)
    current_user.valid_password?(current_password) &&
      password == password_confirmation &&
      password.length >= 6
  end

  def get_token_user
    token = request.headers['Authorization'].split(' ').last
    jwt_payload = JWT.decode(token, Rails.application.credentials.devise_jwt_secret_key!).first
    user = User.find_by(id: jwt_payload['sub'])
    return user if user.present? && user.jti == jwt_payload['jti']

    nil
  end

  def current_user
    get_token_user
  end
end
