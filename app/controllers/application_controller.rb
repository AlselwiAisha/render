# frozen_string_literal: true

# This is the base controller for the application.
class ApplicationController < ActionController::API
  include CanCan::ControllerAdditions
  before_action :configure_permitted_parameters, if: :devise_controller?

  rescue_from CanCan::AccessDenied do |exception|
    render json: { error: 'Access denied', message: exception.message }, status: :forbidden
  end
  
  def current_ability
    shop_id = request.headers['ShopId']
    @current_ability ||= Ability.new(current_user, shop_id)
  end

  protected

  def current_user
    token = extract_token_from_header
    return nil unless token

    jwt_payload = decode_jwt_token(token)
    return nil unless jwt_payload

    @current_user ||= find_current_user(jwt_payload['sub'], jwt_payload['jti'])
  end

  def authenticate_user!
    return if current_user

    return if performed?

    render json: { error: 'You need to sign in or sign up before continuing.', user: current_user },
           status: :unauthorized
  end

  def extract_token_from_header
    authorization_header = request.headers['Authorization']
    return nil unless authorization_header.present?

    authorization_header.split(' ').last
  end

  def decode_jwt_token(token)
    JWT.decode(token, Rails.application.credentials.devise_jwt_secret_key!).first
  rescue JWT::DecodeError
    nil
  end

  def find_current_user(user_id, jti)
    user = User.find(user_id)
    user if user.present? && user.jti == jti
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[name address phone])
    devise_parameter_sanitizer.permit(:account_update, keys: %i[name address phone])
  end
end
