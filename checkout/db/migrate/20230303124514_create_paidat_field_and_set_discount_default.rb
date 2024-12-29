class CreatePaidatFieldAndSetDiscountDefault < ActiveRecord::Migration[7.0]
  def change
    add_column :orders, :paid_at, :datetime, null: true
    change_column_default :orders, :discount, 0
  end
end
