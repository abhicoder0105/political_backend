class Notification < ApplicationRecord
  belongs_to :user
  belongs_to :public_request, optional: true
  belongs_to :from_user, class_name: "User", optional: true

  validates :title, presence: true
  validates :message, presence: true

  scope :unread, -> { where(read: false) }
  scope :recent, -> { order(created_at: :desc) }
end
