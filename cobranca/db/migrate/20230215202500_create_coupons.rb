class CreateCoupons < ActiveRecord::Migration[7.0]
  def change
    create_table :coupons do |t|
      t.string :code
      t.references :promotion, null: false, foreign_key: true
      t.integer :status
      t.date :consumption_date
      t.string :consumption_application

      t.timestamps
    end
  end
end
