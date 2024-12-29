class PlansController < ApplicationController
  before_action :set_plan, only: %i[show edit update]
  def index
    @plans = Plan.order('status desc')
  end

  def show
    @product_groups = ProductGroup.all
  end

  def new
    @plan = Plan.new
    @product_groups = ProductGroup.all
  end

  def edit
    @product_groups = ProductGroup.all
  end

  def create
    @plan = Plan.new(plan_params)
    if @plan.save
      redirect_to plans_path, notice: t('messages.plan.register.success')
    else
      flash.now[:alert] = t('messages.plan.register.fail')
      @product_groups = ProductGroup.all
      render :new
    end
  end

  def update
    if @plan.update(plan_params)
      redirect_to plans_path, notice: t('messages.plan.update.success')
    else
      flash.now[:alert] = t('messages.plan.update.fail')
      @product_groups = ProductGroup.all
      render :edit
    end
  end

  private

  def set_plan
    @plan = Plan.find(params[:id])
  end

  def plan_params
    params.require(:plan).permit(:name, :description, :product_group_id, :details, :status)
  end
end
