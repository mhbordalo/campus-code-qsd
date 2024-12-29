class CallCategoriesController < ApplicationController
  before_action :authenticate_user!, only: %i[index edit update new create]
  before_action :set_call_category, only: %i[edit update]

  def index
    if current_user.administrator?
      @call_categories = CallCategory.all
    else
      flash[:alert] = t('you_have_no_permission_to_access_this_page')
      redirect_to root_path
    end
  end

  def new
    if current_user.administrator?
      @call_category = CallCategory.new
    else
      flash[:alert] = t('you_have_no_permission_to_access_this_page')
      redirect_to root_path
    end
  end

  def edit
    if current_user.administrator?
      @call_category = CallCategory.find(params[:id])
    else
      flash[:alert] = t('you_have_no_permission_to_access_this_page')
      redirect_to root_path
    end
  end

  def create
    @call_category = CallCategory.new(params.require(:call_category).permit(:description))
    if @call_category.save
      flash[:notice] = t('category_successfully_created')
      redirect_to call_categories_path
    else
      flash.now[:alert] = t('not_possible_to_create_category')
      render 'new', status: :unprocessable_entity
    end
  end

  def update
    if @call_category.update(params.require(:call_category).permit(:description))
      flash[:notice] = t('category_successfully_updated')
      redirect_to call_categories_path
    else
      flash.now[:alert] = t('not_possible_to_update_category')
      render 'edit', status: :unprocessable_entity
    end
  end

  private

  def set_call_category
    @call_category = CallCategory.find(params[:id])
  end
end
