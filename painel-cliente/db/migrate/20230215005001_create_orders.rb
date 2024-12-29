class CreateOrders < ActiveRecord::Migration[7.0]
  def change
    create_table :orders do |t|
      t.string :tracking_code
      t.string :product
      t.references :user, null: false, foreign_key: true
      t.float :price
      t.date :purchase_date
      t.integer :status, default: 0

      t.timestamps
    end
  end
end
