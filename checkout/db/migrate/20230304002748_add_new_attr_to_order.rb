class AddNewAttrToOrder < ActiveRecord::Migration[7.0]
  def change
    add_column :orders, :product_group_id, :integer, null: false
    add_column :orders, :product_group_name, :string, null: false
    add_column :orders, :product_plan_id, :integer, null: false
    add_column :orders, :product_plan_periodicity_id, :integer, null: false
  end
end
