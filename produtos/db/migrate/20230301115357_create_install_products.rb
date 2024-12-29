class CreateInstallProducts < ActiveRecord::Migration[7.0]
  def change
    create_table :install_products do |t|
      t.string :customer_document
      t.string :order_code
      t.string :sold_product
      t.references :server, null: false, foreign_key: true

      t.timestamps
    end
  end
end
