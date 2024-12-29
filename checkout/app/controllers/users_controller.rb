class UsersController < ApplicationController
  before_action :authenticate_user!, :redirect_unless_admin, only: %i[index new create edit update lock_unlock]
  before_action :authenticate_user!, only: %i[edit_password update_password]
  before_action :set_user, only: %i[edit update edit_password update_password lock_unlock]

  def index
    @users = if params['query'].nil?
               User.all.page params[:page]
             else
               User.where('name like ?', "%#{params['query']}%").page params[:page]
             end
  end

  def new
    @user = User.new
  end

  def edit; end

  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to users_path, notice: I18n.t('user.msg_record_created')
    else
      render :new
    end
  end

  def update
    user_params_edit = if params[:user][:password].blank?
                         params.require(:user).permit(:email, :name, :admin)
                       else
                         params.require(:user).permit(:email, :name, :password, :password_confirmation, :admin)
                       end

    if @user.update(user_params_edit)
      redirect_to users_path, notice: I18n.t('user.msg_user_changed')
    else
      render :edit
    end
  end

  def edit_password
    redirect_to root_path unless @user == current_user
  end

  def update_password
    redirect_to root_path unless @user == current_user
    user_params_edit = params.require(:user).permit(:password, :password_confirmation)

    if @user.update(user_params_edit)
      redirect_to root_path, notice: I18n.t('user.msg_password_changed')
    else
      render :edit_password
    end
  end

  def lock_unlock
    @user.active = !@user.active
    @user.save
    flash[:notice] = I18n.t('user.msg_user_locked') unless @user.active
    flash[:notice] = I18n.t('user.msg_user_unlocked') if @user.active
    redirect_to users_path
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def redirect_unless_admin
    return if current_user.try(:admin?)

    redirect_to root_path
  end

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation, :name, :admin)
  end
end
