class CreateOrders < ActiveRecord::Migration[7.0]
  def change
    create_table :orders do |t|
      t.references :customer, null: false, foreign_key: true
      t.integer :product_plan_id
      t.integer :product_plan_frequency_id
      t.decimal :price, null: false, precision: 8, scale: 2
      t.decimal :discount, null: true, precision: 8, scale: 2
      t.string :payment_mode, null: true
      t.integer :status, default: 0
      t.string :cancel_reason, null: true

      t.timestamps
    end
  end
end
