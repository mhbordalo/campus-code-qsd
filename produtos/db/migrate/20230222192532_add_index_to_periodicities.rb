class AddIndexToPeriodicities < ActiveRecord::Migration[7.0]
  def change
    add_index :periodicities, :name, unique: true
  end
end
