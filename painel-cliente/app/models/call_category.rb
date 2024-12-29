class CallCategory < ApplicationRecord
  has_many :calls, dependent: :restrict_with_exception
  validates :description, presence: true
  validates :description, uniqueness: true
end
