class RemoveSoldProductFromInstallProduct < ActiveRecord::Migration[7.0]
  def change
    remove_column :install_products, :sold_product, :string
  end
end
