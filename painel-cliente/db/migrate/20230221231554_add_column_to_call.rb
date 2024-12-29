class AddColumnToCall < ActiveRecord::Migration[7.0]
  def change
    add_column :calls, :resolved, :boolean
    add_index :calls, :call_code, unique: true
  end
end
