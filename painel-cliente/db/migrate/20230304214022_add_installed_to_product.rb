class AddInstalledToProduct < ActiveRecord::Migration[7.0]
  def change
    add_column :products, :installed, :integer, default: 0
  end
end
