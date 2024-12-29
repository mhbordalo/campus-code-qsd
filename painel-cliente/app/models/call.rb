class Call < ApplicationRecord
  belongs_to :user
  belongs_to :call_category
  belongs_to :product, optional: true
  has_many :call_messages, dependent: :restrict_with_exception

  validates :call_code, :subject, :description, :status, presence: true
  validates :call_code, uniqueness: true

  enum status: { open: 0, in_progress: 5, closed_solved: 10, closed_unsolved: 15 }

  before_validation :generate_code, on: :create

  private

  def generate_code
    self.call_code = SecureRandom.alphanumeric(6).upcase
  end
end
