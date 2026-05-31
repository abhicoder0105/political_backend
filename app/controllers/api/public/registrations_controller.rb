module Api
  module Public
    class RegistrationsController < ApplicationController
      before_action :validate_mobile_number

      def create
        if signup_with_password?
          register_with_password
        else
          register_with_otp
        end
      end

      private

      def register_with_password
        user = User.new(
          name: params.require(:name),
          mobile_number: params.require(:mobile_number),
          email: params[:email],
          password: params.require(:password),
          password_confirmation: params[:password_confirmation],
          area: params[:area],
          village_or_ward: params[:village_or_ward],
          role: :public_user
        )

        if user.save
          render json: {
            message: "खाता सफलतापूर्वक बनाया गया",
            token: jwt_encode(user_id: user.id, role: user.role),
            user: user.as_public_json
          }
        else
          render_model_errors(user)
        end
      end

      def register_with_otp
        phone = params.require(:mobile_number)
        name = params.require(:name)

        otp_record = MobileOtpVerification.where(phone_number: phone, purpose: "registration")
                                           .where.not(verified_at: nil)
                                           .order(created_at: :desc)
                                           .first

        unless otp_record
          return render json: { error: "पहले OTP सत्यापित करें" }, status: :unprocessable_entity
        end

        if otp_record.verifiable.present?
          return render json: { error: "इस मोबाइल नंबर से पहले ही पंजीकरण हो चुका है" }, status: :unprocessable_entity
        end

        if User.exists?(mobile_number: phone)
          return render json: { error: "यह मोबाइल नंबर पहले से पंजीकृत है" }, status: :unprocessable_entity
        end

        user = User.new(
          name: name,
          mobile_number: phone,
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

      def signup_with_password?
        params[:password].present?
      end

      def validate_mobile_number
        phone = params[:mobile_number]
        if phone.present? && !phone.match?(/\A\d{10}\z/)
          render json: { error: "मोबाइल नंबर 10 अंकों का होना चाहिए" }, status: :unprocessable_entity
        end
      end
    end
  end
end
