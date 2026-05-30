class Otp::SendService
  def self.call(phone_number:, purpose:, ip_address: nil)
    record = MobileOtpVerification.where(phone_number: phone_number, purpose: purpose)
                                   .where("expires_at > ?", Time.current)
                                   .order(created_at: :desc)
                                   .first

    if record
      if record.resend_count >= MobileOtpVerification::MAX_RESENDS
        return { success: false, error: "बहुत अधिक OTP अनुरोध। कृपया बाद में प्रयास करें।" }
      end
      if record.last_sent_at && record.last_sent_at > MobileOtpVerification::RESEND_COOLDOWN.ago
        remaining = (record.last_sent_at + MobileOtpVerification::RESEND_COOLDOWN - Time.current).to_i
        return { success: false, error: "कृपया #{remaining} सेकंड प्रतीक्षा करें", retry_after: remaining }
      end
    end

    otp = Otp::GenerateService.call(phone_number, purpose)
    message = "आपका OTP कोड है: #{otp}. यह 5 मिनट के लिए वैध है।"

    provider = if Rails.env.production?
                 Sms::TwilioProvider.new
               else
                 Sms::DevelopmentProvider.new
               end
    provider.send(phone_number, message)

    { success: true, message: "OTP भेज दिया गया है" }
  end
end
