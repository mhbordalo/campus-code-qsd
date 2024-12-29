class BonusCommission < ApplicationRecord
  scope :active, -> { where(active: true) }

  validates :description, :commission_perc, :amount_limit, presence: true

  validates :start_date, on: %i[create update], comparison: { greater_than_or_equal_to: :actual_date_treatment }
  validates :end_date, comparison: { greater_than: :start_date_treatment }

  private

  def start_date_treatment
    I18n.l(start_date.to_date) unless start_date.nil?
  end

  def actual_date_treatment
    I18n.l(Time.current.to_date)
  end
end
