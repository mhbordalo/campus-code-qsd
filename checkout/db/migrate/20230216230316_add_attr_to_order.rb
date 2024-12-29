class AddAttrToOrder < ActiveRecord::Migration[7.0]
  def change
    add_column :orders, :product_plan_name, :string, null: false
    add_column :orders, :product_plan_periodicity, :string, null: false
    remove_column :orders, :product_plan_id
    remove_column :orders, :product_plan_frequency_id
  end
end
