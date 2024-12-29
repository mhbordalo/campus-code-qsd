class CreateProducts < ActiveRecord::Migration[7.0]
  def change
    create_table :products do |t|
      t.decimal :price, precision: 8, scale: 2
      t.integer :status, default: 0
      t.references :periodicity, null: false, foreign_key: true
      t.references :plan, null: false, foreign_key: true

      t.timestamps
    end
  end
end
