class User < ApplicationRecord
  has_secure_password validations: false

  enum :role, {
    super_admin: 0,
    admin: 1,
    sub_admin: 2,
    district_manager: 3,
    area_manager: 4,
    field_worker: 5,
    volunteer: 6,
    pr_team: 7,
    data_entry_operator: 8,
    complaint_manager: 9,
    campaign_manager: 10,
    public_user: 11
  }

  enum :rural_or_urban, { rural: 0, urban: 1 }

  has_one_attached :profile_photo
  has_many :submitted_requests, class_name: "PublicRequest", foreign_key: :public_user_id, dependent: :nullify, inverse_of: :public_user
  has_many :request_comments, dependent: :nullify
  has_many :request_histories, dependent: :nullify

  validates :mobile_number, presence: { message: "मोबाइल नंबर आवश्यक है" },
            uniqueness: { message: "यह मोबाइल नंबर पहले से पंजीकृत है" },
            format: { with: /\A\d{10}\z/, message: "मोबाइल नंबर 10 अंकों का होना चाहिए" }
  validates :name, format: { with: /\A[\p{L} .'-]+\z/, message: "नाम में केवल अक्षर और स्थान हो सकते हैं", allow_blank: true }
  validates :role, presence: { message: "भूमिका आवश्यक है" }, inclusion: { in: roles.keys, message: "%{value} एक मान्य भूमिका नहीं है" }
  validates :password, length: { minimum: 6, message: "पासवर्ड कम से कम 6 अक्षर का होना चाहिए" }, if: -> { password.present? }
  validates :otp_code, format: { with: /\A\d{6}\z/, message: "OTP 6 अंकों का होना चाहिए" }, allow_blank: true

  def permission?(permission_key)
    super_admin? || RolePermission.joins(:permission).exists?(role: self.class.roles[role], permissions: { key: permission_key })
  end
end
