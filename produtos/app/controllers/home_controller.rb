class HomeController < ApplicationController
  before_action :authenticate_user!, only: %i[index]
  def index
    @server = Server.count
    @installproduct = InstallProduct.active.count
    @plan = Plan.active.count
  end
end
