class CreatePlans < ActiveRecord::Migration[7.0]
  def change
    create_table :plans do |t|
      t.string :name
      t.string :description
      t.references :product_group, null: false, foreign_key: true
      t.integer :status, default: 0

      t.timestamps
    end
  end
end
