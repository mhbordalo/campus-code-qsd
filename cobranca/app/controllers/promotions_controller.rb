class PromotionsController < ApplicationController
  before_action :promotion_products_api, only: %i[new create edit update]

  def index
    @promotions = Promotion.all
  end

  def show
    @promotion = Promotion.find(params[:id])
    @user_create = User.find(@promotion.user_create)
    @user_aprove = User.find(@promotion.user_aprove) unless @promotion.user_aprove.nil?
    @coupons = @promotion.coupons.order(:status).page params[:page]
  end

  def new
    @promotion = Promotion.new
  end

  def edit
    @promotion = Promotion.find(params[:id])
  end

  def create
    @promotion = Promotion.new(promotion_params)
    @promotion.user_create = current_user.id
    if @promotion.save
      @promotion.pending!
      flash[:notice] = t('success_promotion_created')
      redirect_to @promotion
    else
      flash[:alert] = t('fail_promotion_created')
      render :new
    end
  end

  def update
    @promotion = Promotion.find(params[:id])
    if @promotion.update(promotion_params)
      flash[:notice] = t(:success_promotion_updated)
      redirect_to @promotion
    else
      flash.now[:alert] = t(:fail_promotion_updated)
      render :edit
    end
  end

  # rubocop:disable Metrics/AbcSize
  def activated
    promotion = Promotion.find(params[:id])
    promotion.user_aprove = current_user.id
    if promotion.save
      promotion.activated!
      Coupon.generate_coupons(promotion.coupon_quantity, promotion.id)
      flash[:notice] = t(:aprove_promotion)
    else
      flash[:alert] = t(:fail_diferent_user)
    end
    redirect_to promotion
  end
  # rubocop:enable Metrics/AbcSize

  private

  def promotion_params
    params.require(:promotion).permit(:name, :code, :start, :finish, :discount,
                                      :maximum_discount_value, :coupon_quantity, :approve_date, products: [])
  end

  def promotion_products_api
    @check = Product.all
  rescue StandardError
    flash.now[:alert] = t('products_api_fail')
    @check = ''
  end
end
