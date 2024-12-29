class AddOrderCodeToCoupons < ActiveRecord::Migration[7.0]
  def change
    add_column :coupons, :order_code, :string
  end
end
