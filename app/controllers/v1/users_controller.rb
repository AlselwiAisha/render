class V1::UsersController < ApplicationController
  load_and_authorize_resource class: 'User'

  def create
    if user_exist[1]
      user = user_exist[0]
      return render json: { message: 'User already exists and found', user: user.id }, status: :found
    end
    user = User.create(user_params)
    if user.save
      render json: { message: 'User created successfully', user: user.id }, status: :created
    else
      render json: { message: 'User not created', errors: user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def user_exist
    user = User.find_by(email: user_params[:email])
    return user, true if user.present?

    [nil, false]
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :address, :phone)
  end
end
