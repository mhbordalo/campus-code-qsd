class AddStatusToInstallProduct < ActiveRecord::Migration[7.0]
  def change
    add_column :install_products, :status, :integer, default: 1
  end
end
