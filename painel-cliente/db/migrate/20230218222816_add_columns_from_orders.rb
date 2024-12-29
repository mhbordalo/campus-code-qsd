class AddColumnsFromOrders < ActiveRecord::Migration[7.0]
  def change
    add_column :orders, :order_code, :string
    add_column :orders, :salesman_id, :integer
    add_column :orders, :product_plan_name, :string
    add_column :orders, :product_plan_periodicity, :string
    add_column :orders, :discount, :integer
    add_column :orders, :payment_mode, :string
    add_column :orders, :cancel_reason, :string
  end
end
