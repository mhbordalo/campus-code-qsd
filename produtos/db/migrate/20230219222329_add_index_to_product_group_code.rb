class AddIndexToProductGroupCode < ActiveRecord::Migration[7.0]
  def change
    add_index :product_groups, :code, unique: true
  end
end
