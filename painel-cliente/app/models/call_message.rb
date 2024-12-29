class CallMessage < ApplicationRecord
  belongs_to :call
  belongs_to :user

  validates :message, presence: true
end
