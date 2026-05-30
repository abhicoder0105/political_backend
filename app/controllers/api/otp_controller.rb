module Api
  class OtpController < ApplicationController
    def send_otp
      phone = params.require(:phone_number)
      purpose = params[:purpose] || 'login'

      unless phone.match?(/\A\d{10}\z/)
        return render json: { error: "मोबाइल नंबर 10 अंकों का होना चाहिए" }, status: :unprocessable_entity
      end

      result = Otp::SendService.call(phone_number: phone, purpose: purpose, ip_address: request.remote_ip)

      if result[:success]
        render json: { message: result[:message] }
      else
        status = result[:error].include?("प्रतीक्षा") ? :too_many_requests : :unprocessable_entity
        render json: { error: result[:error], retry_after: result[:retry_after] }, status: status
      end
    end

    def verify_otp
      phone = params.require(:phone_number)
      otp = params.require(:otp)
      purpose = params[:purpose] || 'login'

      unless otp.match?(/\A\d{6}\z/)
        return render json: { error: "OTP 6 अंकों का होना चाहिए" }, status: :unprocessable_entity
      end

      result = Otp::VerifyService.call(phone_number: phone, otp: otp, purpose: purpose)

      if result[:success]
        user = User.find_by(mobile_number: phone)
        render json: {
          message: result[:message],
          verified: true,
          user_exists: user.present?,
          token: user ? jwt_encode(user_id: user.id, role: user.role) : nil,
          user: user ? user.as_json(only: %i[id name mobile_number role area village_or_ward]) : nil
        }
      else
        render json: { error: result[:error], verified: false }, status: :unprocessable_entity
      end
    end

    def register
      phone = params.require(:phone_number)
      name = params.require(:name)

      unless phone.match?(/\A\d{10}\z/)
        return render json: { error: "मोबाइल नंबर 10 अंकों का होना चाहिए" }, status: :unprocessable_entity
      end

      otp_record = MobileOtpVerification.where(phone_number: phone, purpose: "login")
                                         .where.not(verified_at: nil)
                                         .order(created_at: :desc)
                                         .first

      unless otp_record
        return render json: { error: "पहले OTP सत्यापित करें" }, status: :unprocessable_entity
      end

      user = User.find_or_initialize_by(mobile_number: phone)
      user.assign_attributes(
        name: name,
        area: params[:area],
        village_or_ward: params[:village_or_ward],
        role: :public_user
      )

      if user.save
        render json: {
          token: jwt_encode(user_id: user.id, role: user.role),
          user: user.as_json(only: %i[id name mobile_number role area village_or_ward])
        }
      else
        render_model_errors(user)
      end
    end
  end
end
