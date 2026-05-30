module Api
  class AuthController < ApplicationController
    def request_otp
      user = User.find_or_initialize_by(mobile_number: params.require(:mobile_number))
      user.name ||= params[:name]
      user.role ||= params[:public_user] ? :public_user : :field_worker
      user.otp_code = "123456"
      user.otp_requested_at = Time.current

      if user.save
        render json: { message: "OTP placeholder generated", otp_placeholder: user.otp_code }
      else
        render_model_errors(user)
      end
    end

    def verify_otp
      user = User.find_by(mobile_number: params.require(:mobile_number), otp_code: params.require(:otp_code))

      if user
        render json: auth_payload(user)
      else
        render json: { error: "Invalid OTP" }, status: :unauthorized
      end
    end

    def admin_login
      user = User.find_by(mobile_number: params.require(:mobile_number))

      if user&.authenticate(params.require(:password)) && (user.super_admin? || user.admin?)
        render json: auth_payload(user)
      else
        render json: { error: "Invalid admin credentials" }, status: :unauthorized
      end
    end

    private

    def auth_payload(user)
      {
        token: jwt_encode(user_id: user.id, role: user.role),
        user: user.as_json(only: %i[id name mobile_number phone_number role address village_or_ward area rural_or_urban preferred_language])
      }
    end
  end
end
