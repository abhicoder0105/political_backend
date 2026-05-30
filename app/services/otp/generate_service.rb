class Otp::GenerateService
  def self.call(phone_number, purpose)
    otp = rand(100000..999999).to_s
    digest = Digest::SHA256.hexdigest(otp)

    MobileOtpVerification.create!(
      phone_number: phone_number,
      otp_digest: digest,
      purpose: purpose,
      expires_at: MobileOtpVerification::OTP_EXPIRY.from_now,
      attempts_count: 0,
      resend_count: 0,
      last_sent_at: Time.current,
      ip_address: nil
    )

    otp
  end
end
