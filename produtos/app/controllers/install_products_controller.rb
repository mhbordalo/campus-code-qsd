class InstallProductsController < ApplicationController
  def index
    @install_products = InstallProduct.in_order_of(:status, %w[active inactive])
  end
end
