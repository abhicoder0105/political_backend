class Otp::VerifyService
  def self.call(phone_number:, otp:, purpose:)
    unless otp.match?(/\A\d{6}\z/)
      return { success: false, error: "OTP 6 अंकों का होना चाहिए" }
    end

    record = MobileOtpVerification.where(phone_number: phone_number, purpose: purpose)
                                   .valid
                                   .order(created_at: :desc)
                                   .first

    unless record
      return { success: false, error: "कोई वैध OTP नहीं मिला। कृपया पहले OTP भेजें।" }
    end

    if record.max_attempts_reached?
      record.invalidate!
      return { success: false, error: "बहुत अधिक गलत प्रयास। कृपया पुनः OTP भेजें।" }
    end

    expected_digest = record.otp_digest
    actual_digest = Digest::SHA256.hexdigest(otp)

    if expected_digest != actual_digest
      record.increment!(:attempts_count)
      remaining = MobileOtpVerification::MAX_ATTEMPTS - record.attempts_count
      if remaining <= 0
        record.invalidate!
        return { success: false, error: "बहुत अधिक गलत प्रयास। कृपया पुनः OTP भेजें।" }
      end
      return { success: false, error: "गलत OTP। #{remaining} प्रयास शेष।" }
    end

    record.update!(verified_at: Time.current, attempts_count: record.attempts_count + 1)
    { success: true, message: "मोबाइल नंबर सत्यापित हो गया" }
  end
end
