module Api
  class PublicUsersController < ApplicationController
    before_action :authenticate_user!, except: %i[request_otp verify_otp]
    before_action :ensure_public_user!, except: %i[request_otp verify_otp]

    def request_otp
      user = User.find_or_initialize_by(mobile_number: params.require(:mobile_number))
      user.assign_attributes(public_user_params.merge(role: :public_user))
      user.otp_code = "123456"
      user.otp_requested_at = Time.current

      if user.save
        render json: { message: "OTP placeholder generated", otp_placeholder: user.otp_code }
      else
        render_model_errors(user)
      end
    end

    def verify_otp
      user = User.public_user.find_by(mobile_number: params.require(:mobile_number), otp_code: params.require(:otp_code))

      if user
        render json: { token: jwt_encode(user_id: user.id, role: user.role), user: profile_json(user) }
      else
        render json: { error: "Invalid OTP" }, status: :unauthorized
      end
    end

    def profile
      render json: profile_json(current_user)
    end

    def update_profile
      if current_user.update(public_user_params)
        current_user.profile_photo.attach(params[:profile_photo]) if params[:profile_photo].present?
        render json: profile_json(current_user)
      else
        render_model_errors(current_user)
      end
    end

    def requests
      render json: current_user.submitted_requests.order(created_at: :desc).as_json(include: [:request_comments, :request_histories])
    end

    private

    def ensure_public_user!
      render json: { error: "Forbidden" }, status: :forbidden unless current_user&.public_user?
    end

    def public_user_params
      params.permit(:name, :mobile_number, :phone_number, :address, :village_or_ward, :area, :rural_or_urban, :preferred_language)
    end

    def profile_json(user)
      user.as_json(only: %i[id name mobile_number phone_number address village_or_ward area rural_or_urban preferred_language role])
    end
  end
end
