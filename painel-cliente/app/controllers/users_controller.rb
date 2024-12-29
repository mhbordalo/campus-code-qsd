class UsersController < ApplicationController
  before_action :authenticate_user!, only: %i[inactive set_inactive]

  def inactive; end

  def set_inactive
    current_user.inactive!
    sign_out(current_user)
    redirect_to root_path, notice: t('account_inactivated_with_success')
  end
end
