class AddCouponToOrder < ActiveRecord::Migration[7.0]
  def change
    add_column :orders, :coupon_code, :string
  end
end
