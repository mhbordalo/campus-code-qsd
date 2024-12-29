class ProductGroupsController < ApplicationController
  before_action :set_product_group, only: %i[show edit update]

  def index
    @product_groups = ProductGroup.all
  end

  def show; end

  def new
    @product_group = ProductGroup.new
  end

  def edit; end

  def create
    @product_group = ProductGroup.new(product_group_params)
    if @product_group.save
      redirect_to @product_group, notice: t('messages.product_group.register.success')
    else
      flash.now[:alert] = t('messages.product_group.register.fail')
      render :new
    end
  end

  def update
    if @product_group.update(product_group_params)
      redirect_to @product_group, notice: t('messages.product_group.update.success')
    else
      flash.now[:alert] = t('messages.product_group.update.fail')
      render :edit
    end
  end

  private

  def product_group_params
    params.require(:product_group).permit(:name, :description, :code, :status, :icon)
  end

  def set_product_group
    @product_group = ProductGroup.find(params[:id])
  end
end
