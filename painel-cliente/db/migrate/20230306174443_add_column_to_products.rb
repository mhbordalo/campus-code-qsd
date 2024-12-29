class AddColumnToProducts < ActiveRecord::Migration[7.0]
  def change
    add_column :products, :installation, :integer, default: 0
  end
end
