class Otp::SendService
  IP_COOLDOWN = 60.seconds
  MAX_IP_REQUESTS = 10

  def self.call(phone_number:, purpose:, ip_address: nil)
    if ip_address.present?
      recent_from_ip = MobileOtpVerification.where(ip_address: ip_address)
                                            .where("created_at > ?", IP_COOLDOWN.ago)
                                            .count
      if recent_from_ip >= MAX_IP_REQUESTS
        return { success: false, error: "बहुत अधिक अनुरोध। कृपया बाद में प्रयास करें।" }
      end
    end

    latest = MobileOtpVerification.where(phone_number: phone_number, purpose: purpose)
                                   .where("expires_at > ?", Time.current)
                                   .order(created_at: :desc)
                                   .first

    if latest
      if latest.max_resends_reached?
        return { success: false, error: "बहुत अधिक OTP अनुरोध। कृपया बाद में प्रयास करें।" }
      end
      if latest.within_cooldown?
        remaining = latest.cooldown_remaining
        return { success: false, error: "कृपया #{remaining} सेकंड प्रतीक्षा करें", retry_after: remaining }
      end
    end

    record = MobileOtpVerification.where(phone_number: phone_number, purpose: purpose)
                                  .unverified
                                  .where("expires_at > ?", Time.current)
                                  .order(created_at: :desc)
                                  .first

    if record
      if record.resend_count < MobileOtpVerification::MAX_RESENDS
        record.increment!(:resend_count)
        record.update!(last_sent_at: Time.current, expires_at: MobileOtpVerification::OTP_EXPIRY.from_now)
        otp = Rails.logger.warn("[DEV ONLY] Resending OTP - generating new one")
      end
    end

    otp = Otp::GenerateService.call(phone_number: phone_number, purpose: purpose, ip_address: ip_address)
    message = "आपका OTP कोड है: #{otp}. यह 5 मिनट के लिए वैध है।"

    provider = SmsProviderResolver.resolve
    provider.send(phone_number, message)

    { success: true, message: "OTP भेज दिया गया है" }
  end
end
