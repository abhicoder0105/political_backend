module Api
  class OtpController < ApplicationController
    def send_otp
      phone = params.require(:phone_number)
      purpose = params[:purpose] || "registration"

      unless phone.match?(/\A\d{10}\z/)
        return render json: { error: "मोबाइल नंबर 10 अंकों का होना चाहिए" }, status: :unprocessable_entity
      end

      result = Otp::SendService.call(
        phone_number: phone,
        purpose: purpose,
        ip_address: request.remote_ip
      )

      if result[:success]
        render json: { message: result[:message], otp: result[:otp] }
      else
        status = result[:error].include?("प्रतीक्षा") ? :too_many_requests : :unprocessable_entity
        render json: { error: result[:error], retry_after: result[:retry_after] }, status: status
      end
    end

    def verify_otp
      phone = params.require(:phone_number)
      otp = params.require(:otp)
      purpose = params[:purpose] || "registration"

      result = Otp::VerifyService.call(phone_number: phone, otp: otp, purpose: purpose)

      if result[:success]
        render json: {
          message: result[:message],
          verified: true
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

      otp_record = MobileOtpVerification.where(phone_number: phone, purpose: "registration")
                                         .where.not(verified_at: nil)
                                         .order(created_at: :desc)
                                         .first

      unless otp_record
        return render json: { error: "पहले OTP सत्यापित करें" }, status: :unprocessable_entity
      end

      unless otp_record.verifiable_type.nil?
        return render json: { error: "इस मोबाइल नंबर से पहले ही पंजीकरण हो चुका है" }, status: :unprocessable_entity
      end

      user = User.find_or_initialize_by(mobile_number: phone)

      if user.persisted?
        return render json: { error: "यह मोबाइल नंबर पहले से पंजीकृत है" }, status: :unprocessable_entity
      end

      user.assign_attributes(
        name: name,
        email: params[:email],
        area: params[:area],
        village_or_ward: params[:village_or_ward],
        role: :public_user
      )

      if user.save
        otp_record.update!(verifiable: user)

        render json: {
          message: "खाता सफलतापूर्वक बनाया गया",
          token: jwt_encode(user_id: user.id, role: user.role),
          user: user.as_public_json
        }
      else
        render_model_errors(user)
      end
    end
  end
end
