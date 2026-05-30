class RequestHistory < ApplicationRecord
  belongs_to :public_request
  belongs_to :user, optional: true
end
