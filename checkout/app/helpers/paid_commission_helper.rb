module PaidCommissionHelper
  def period_desc(start_date, end_date)
    "De: #{start_date == '' ? 'primeiro dado disponível' : I18n.l(start_date, format: :default)} " \
      "até: #{end_date == '' ? 'último dado disponível' : I18n.l(end_date, format: :default)}"
  end
end
