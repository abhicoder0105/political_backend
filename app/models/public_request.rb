class PublicRequest < ApplicationRecord
  belongs_to :public_user, class_name: "User", optional: true, inverse_of: :submitted_requests
  belongs_to :assigned_to_user, class_name: "User", optional: true
  has_many :request_comments, dependent: :destroy
  has_many :request_histories, dependent: :destroy
  has_many :request_activities, dependent: :destroy
  has_one_attached :attachment
  has_many_attached :resolution_proofs

  enum :category, {
    water: "water",
    electricity: "electricity",
    road: "road",
    hospital: "hospital",
    police: "police",
    pension: "pension",
    government_scheme: "government_scheme",
    education: "education",
    sanitation: "sanitation",
    corruption: "corruption",
    emergency: "emergency",
    other: "other"
  }
  enum :severity, { low: 0, medium: 1, high: 2, critical: 3 }
  enum :status, { new_request: 0, assigned: 1, in_progress: 2, resolved: 3, rejected: 4, escalated: 5 }

  validates :name, presence: { message: "नाम आवश्यक है" },
            format: { with: /\A[\p{L} .'-]+\z/, message: "नाम में केवल अक्षर और स्थान हो सकते हैं" }
  validates :phone_number, presence: { message: "मोबाइल नंबर आवश्यक है" },
            format: { with: /\A\d{10}\z/, message: "मोबाइल नंबर 10 अंकों का होना चाहिए" }
  validates :area, presence: { message: "क्षेत्र आवश्यक है" },
            length: { maximum: 200, message: "क्षेत्र 200 अक्षर से अधिक नहीं होना चाहिए" }
  validates :village_or_ward, presence: { message: "गांव/वार्ड आवश्यक है" },
            length: { maximum: 200, message: "गांव 200 अक्षर से अधिक नहीं होना चाहिए" }
  validates :category, presence: { message: "श्रेणी आवश्यक है" },
            inclusion: { in: categories.keys, message: "%{value} एक मान्य श्रेणी नहीं है", allow_blank: true }
  validates :description, presence: { message: "विवरण आवश्यक है" },
            length: { minimum: 10, maximum: 10000, message: "विवरण 10 से 10000 अक्षरों के बीच होना चाहिए" }
  validates :request_title, length: { maximum: 500, message: "शीर्षक 500 अक्षर से अधिक नहीं होना चाहिए" }, allow_blank: true
  validates :severity, inclusion: { in: severities.keys, message: "%{value} एक मान्य गंभीरता स्तर नहीं है" }, allow_blank: true
  validates :status, inclusion: { in: statuses.keys, message: "%{value} एक मान्य स्थिति नहीं है" }, allow_blank: true
  validates :expected_resolution_date, comparison: { greater_than_or_equal_to: Date.current, message: "अपेक्षित समाधान तिथि आज या भविष्य की होनी चाहिए" }, allow_nil: true

  before_validation :sync_public_user_fields
  before_validation :classify_severity, on: :create
  after_create :record_created_activity

  scope :search_text, ->(term) {
    if term.present?
      value = "%#{sanitize_sql_like(term.downcase)}%"
      where(
        "LOWER(name) LIKE :value OR LOWER(phone_number) LIKE :value OR LOWER(request_title) LIKE :value OR LOWER(description) LIKE :value",
        value: value
      )
    end
  }
  scope :unresolved, -> { where.not(status: statuses.values_at("resolved", "rejected")) }

  private

  def sync_public_user_fields
    return unless public_user

    self.name ||= public_user.name
    self.phone_number ||= public_user.mobile_number
    self.area ||= public_user.area
    self.village_or_ward ||= public_user.village_or_ward
  end

  def classify_severity
    self.severity = AiSeverityClassifier.new(self).call
  end

  def record_created_activity
    request_activities.create!(action: "created", new_value: status, notes: "Request created")
  end
end
