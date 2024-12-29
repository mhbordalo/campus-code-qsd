class CreatePromotions < ActiveRecord::Migration[7.0]
  def change
    create_table :promotions do |t|
      t.string :code
      t.string :name
      t.date :start
      t.date :finish
      t.integer :discount
      t.decimal :maximum_discount_value
      t.integer :coupon_quantity
      t.integer :status
      t.date :approve_date
      t.date :approval_date

      t.timestamps
    end
  end
end
