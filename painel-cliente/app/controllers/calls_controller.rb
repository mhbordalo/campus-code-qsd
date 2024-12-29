class CallsController < ApplicationController
  before_action :authenticate_user!, only: %i[index show new create]
  before_action :set_products_categories, only: %i[new create]
  before_action :set_call_by_id, only: %i[show close close_solved close_unsolved]
  def index
    @calls = Call.joins(:user).order(:name) if current_user.administrator?
    @calls = Call.where(user: current_user) unless current_user.administrator?
  end

  def show
    @call_messages = @call.call_messages
  end

  def new
    if current_user.client?
      @call = Call.new
    else
      flash[:alert] = t('you_have_no_permission_to_access_this_page')
      redirect_to calls_path
    end
  end

  def create
    @call = Call.new(call_params)
    @call.user = current_user
    if @call.save
      flash[:notice] = t('call_created_successfully')
      redirect_to calls_path
    else
      flash.now[:alert] = t('create_call_error')
      render :new, status: :unprocessable_entity
    end
  end

  def close; end

  def close_solved
    return redirect_to calls_path, notice: t('call_successfully_closed') if @call.closed_solved!

    flash.now[:alert] = t('closing_call_error')
    render :index, status: :unprocessable_entity
  end

  def close_unsolved
    return redirect_to calls_path, notice: t('call_successfully_closed') if @call.closed_unsolved!

    flash.now[:alert] = t('closing_call_error')
    render :index, status: :unprocessable_entity
  end

  private

  def set_call_by_id
    @call = Call.find(params[:id])
  end

  def set_products_categories
    @products = Product.where(user_id: current_user, installation: 5)
    @call_categories = CallCategory.all
  end

  def call_params
    params.require(:call).permit(:call_code, :subject, :description, :status,
                                 :user_id, :product_id, :call_category_id)
  end
end
