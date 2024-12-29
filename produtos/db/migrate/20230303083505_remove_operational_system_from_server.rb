class RemoveOperationalSystemFromServer < ActiveRecord::Migration[7.0]
  def change
    remove_column :servers, :operational_system, :string
  end
end
