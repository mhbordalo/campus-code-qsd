class CreateProducts < ActiveRecord::Migration[7.0]
  def change
    create_table :products do |t|
      t.references :user, null: false, foreign_key: true
      t.float :price
      t.date :purchase_date
      t.integer :status, default: 0
      t.string :order_code
      t.string :salesman
      t.string :product_plan_name
      t.string :product_plan_periodicity
      t.integer :discount
      t.string :payment_mode
      t.text :cancel_reason
      t.string :installation_code
      t.string :server_code

      t.timestamps
    end
  end
end
