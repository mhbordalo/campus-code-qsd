class PaidCommissionsController < ApplicationController
  before_action :authenticate_user!, :redirect_unless_admin, only: %i[index salesman]

  def index
    @query_salesman = params[:search_salesman]
    @start_date = date_or_empty(params[:start_date])
    @end_date = date_or_empty(params[:end_date])
    @paid_commissions = PaidCommission.load_all_commissions
    return flash.now[:notice] = 'Nenhum filtro aplicado' if no_filter_applied

    salesmen_commissions = PaidCommission.filtered_commissions(@query_salesman, @start_date, @end_date)
    no_results_found(salesmen_commissions)
    @paid_commissions = salesmen_commissions
  end

  def salesman_detail
    @user = User.find(params[:user_id])
    @start_date = date_or_empty(params[:start_date])
    @end_date = date_or_empty(params[:end_date])
    @paid_commissions = @user.paid_commissions
                             .after_start_date(@start_date)
                             .before_end_date(@end_date)
  end

  private

  def no_filter_applied
    @query_salesman.blank? && @start_date.blank? && @end_date.blank?
  end

  def redirect_unless_admin
    return if current_user.try(:admin?)
  end

  def date_or_empty(date)
    date.nil? || date == '' ? '' : date.to_date
  end

  def no_results_found(salesman_commissions)
    return unless salesman_commissions.empty?

    flash.now[:alert] = 'Não foram encontradas comissões pagas para esse critério'
    @paid_commissions = nil
    render :index
  end
end
