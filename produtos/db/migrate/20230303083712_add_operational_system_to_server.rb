class AddOperationalSystemToServer < ActiveRecord::Migration[7.0]
  def change
    add_column :servers, :operational_system, :integer
  end
end
