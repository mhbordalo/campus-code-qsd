class BlocklistedCustomer < ApplicationRecord
  validates :blocklisted_reason, presence: true
  validates :doc_ident, uniqueness: true
end
