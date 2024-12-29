class BonusCommissionsController < ApplicationController
  before_action :authenticate_user!, only: %i[index]

  def index
    @bonus_commissions = BonusCommission.where(active: true)
  end

  def new
    @bonus_commission = BonusCommission.new
  end

  def edit
    @bonus_commission = BonusCommission.find(params[:id])
  end

  def create
    @bonus_commission = BonusCommission.new(params.require(:bonus_commission).permit(:description, :start_date,
                                                                                     :end_date, :commission_perc,
                                                                                     :amount_limit))

    render :new and return if create_date_validation == 1

    create_data
  end

  def update
    @bonus_commission = BonusCommission.update(params[:id], params.require(:bonus_commission).permit(:description,
                                                                                                     :start_date,
                                                                                                     :end_date,
                                                                                                     :commission_perc,
                                                                                                     :amount_limit))

    render :edit and return if update_date_validation == 1
    redirect_to bonus_commissions_path and return if @bonus_commission.valid?

    flash.now[:alert] = I18n.t('bonus_commission.msg_create_unsuccess')
    render :edit
  end

  def deactive
    BonusCommission.update(params[:id], active: false)
    redirect_to bonus_commissions_path
  end

  def update_date_validation
    if update_date_start
      flash.now[:alert] = I18n.t('bonus_commission.msg_create_unsuccess_start_date') and 1
    elsif update_date_end
      flash.now[:alert] = I18n.t('bonus_commission.msg_create_unsuccess_end_date') and 1
    elsif update_date_interval
      flash.now[:alert] = I18n.t('bonus_commission.msg_create_unsuccess_interval') and 1
    end
  end

  def update_date_start
    !BonusCommission.where('start_date <= ? and end_date >= ? and active = ? and id <> ?',
                           @bonus_commission.start_date, @bonus_commission.start_date, true, params[:id]).empty?
  end

  def update_date_end
    !BonusCommission.where('start_date <= ? and end_date >= ? and active = ? and id <> ?',
                           @bonus_commission.end_date, @bonus_commission.end_date, true, params[:id]).empty?
  end

  def update_date_interval
    !BonusCommission.where('start_date >= ? and end_date <= ? and active = ? and id <> ?',
                           @bonus_commission.start_date, @bonus_commission.end_date, true, params[:id]).empty?
  end

  def create_date_validation
    if create_date_start
      flash.now[:alert] = I18n.t('bonus_commission.msg_create_unsuccess_start_date') and 1
    elsif create_date_end
      flash.now[:alert] = I18n.t('bonus_commission.msg_create_unsuccess_end_date') and 1
    elsif create_date_interval
      flash.now[:alert] = I18n.t('bonus_commission.msg_create_unsuccess_interval') and 1
    end
  end

  def create_date_start
    !BonusCommission.where('start_date <= ? and end_date >= ? and active = ?',
                           @bonus_commission.start_date, @bonus_commission.start_date, true).empty?
  end

  def create_date_end
    !BonusCommission.where('start_date <= ? and end_date >= ? and active = ?',
                           @bonus_commission.end_date, @bonus_commission.end_date, true).empty?
  end

  def create_date_interval
    !BonusCommission.where('start_date >= ? and end_date <= ? and active = ?',
                           @bonus_commission.start_date, @bonus_commission.end_date, true).empty?
  end

  def create_data
    if @bonus_commission.save
      BonusCommission.update(@bonus_commission.id, active: true)
      flash.now[:notice] = I18n.t('bonus_commission.msg_create_success')
      redirect_to(bonus_commissions_path) and return
    else
      flash.now[:alert] = I18n.t('bonus_commission.msg_create_unsuccess')
      render :new
    end
  end
end
