class MobileOtpVerification < ApplicationRecord
  belongs_to :verifiable, polymorphic: true, optional: true

  validates :phone_number, presence: true,
            format: { with: /\A\d{10}\z/, message: "मोबाइल नंबर 10 अंकों का होना चाहिए" }
  validates :purpose, presence: true
  validates :attempts_count, numericality: { less_than_or_equal_to: 5, message: "बहुत अधिक प्रयास" }

  scope :valid, -> { where(verified_at: nil).where("expires_at > ?", Time.current) }
  scope :for_purpose, ->(purpose) { where(purpose: purpose) }
  scope :latest_first, -> { order(created_at: :desc) }
  scope :unverified, -> { where(verified_at: nil) }

  MAX_ATTEMPTS = 5
  MAX_RESENDS = 5
  OTP_EXPIRY = 5.minutes
  RESEND_COOLDOWN = 30.seconds

  def expired?
    expires_at.present? && expires_at < Time.current
  end

  def verified?
    verified_at.present?
  end

  def max_attempts_reached?
    attempts_count >= MAX_ATTEMPTS
  end

  def max_resends_reached?
    resend_count >= MAX_RESENDS
  end

  def within_cooldown?
    last_sent_at.present? && last_sent_at > RESEND_COOLDOWN.ago
  end

  def cooldown_remaining
    return 0 unless last_sent_at.present?
    remaining = (last_sent_at + RESEND_COOLDOWN - Time.current).to_i
    [remaining, 0].max
  end

  def invalidate!
    update!(expires_at: Time.current)
  end
end
