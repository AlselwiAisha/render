# frozen_string_literal: true

# This handles the Version 1 APIs.
module V1
  module Users
    # This handles the sessions of the user.
    class SessionsController < Devise::SessionsController
      include RackSessionsFix

      respond_to :json

      def create
        user = User.find_by(email: params[:user][:email])
        if user&.valid_password?(params[:user][:password])
          token = encode_jwt_token(user)
          render json: { head: token, message: 'Logged in successfully.', email: user.email, created_at: user.created_at },
                 status: :ok
        else
          render json: { status: 401, message: 'Invalid email or password.' }, status: :unauthorized
        end
      end

      private

      def respond_to_on_destroy
        if request.headers['Authorization'].present?
          jwt_payload = decode_jwt_token(request.headers['Authorization'])
          current_user = User.find(jwt_payload['sub'])
        end
        if current_user && current_user.jti == jwt_payload['jti']
          render json: { status: 200, message: 'Logged out successfully.' }, status: :ok
        else
          render json: { status: 401, message: "Couldn't find an active session." }, status: :unauthorized
        end
      end

      protected

      def decode_jwt_token(_token)
        JWT.decode(
          request.headers['Authorization'].split(' ').last,
          Rails.application.credentials.devise_jwt_secret_key!
        ).first
      end

      def encode_jwt_token(user)
        jwt_payload = { sub: user.id, jti: user.jti }
        JWT.encode(jwt_payload, Rails.application.credentials.devise_jwt_secret_key!)
      end
    end
  end
end
