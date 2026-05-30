class MobileOtpVerification < ApplicationRecord
  belongs_to :verifiable, polymorphic: true, optional: true

  validates :phone_number, presence: true,
            format: { with: /\A\d{10}\z/, message: "मोबाइल नंबर 10 अंकों का होना चाहिए" }
  validates :purpose, presence: true
  validates :attempts_count, numericality: { less_than_or_equal_to: 5, message: "बहुत अधिक प्रयास" }

  scope :valid, -> { where(verified_at: nil).where("expires_at > ?", Time.current) }

  MAX_ATTEMPTS = 5
  MAX_RESENDS = 5
  OTP_EXPIRY = 5.minutes
  RESEND_COOLDOWN = 30.seconds
end
