class RemoveColumnsFromOrders < ActiveRecord::Migration[7.0]
  def change
    remove_column :orders, :tracking_code, :string
    remove_column :orders, :product, :string
  end
end
