class ServersController < ApplicationController
  before_action :set_server, only: %i[show edit update]

  def index
    @servers = Server.all
  end

  def show
    @instalacoes = InstallProduct.active.where(server: params[:id]).count
  end

  def new
    @server = Server.new
    @product_groups = ProductGroup.all
  end

  def edit
    @product_groups = ProductGroup.all
  end

  def create
    @server = Server.new(server_params)
    if @server.save
      redirect_to servers_path, notice: t('messages.server.register.success')
    else
      flash.now[:alert] = t('messages.server.register.fail')
      @product_groups = ProductGroup.all
      render :new
    end
  end

  def update
    if @server.update(server_params)
      redirect_to servers_path, notice: t('messages.server.update.success')
    else
      flash.now[:alert] = t('messages.server.update.fail')
      @product_groups = ProductGroup.all
      render :edit
    end
  end

  private

  def set_server
    @server = Server.find(params[:id])
  end

  def server_params
    params.require(:server).permit(:operational_system, :os_version,
                                   :type_of_storage, :storage_capacity,
                                   :amount_of_ram, :number_of_cpus,
                                   :max_installations, :product_group_id)
  end
end
