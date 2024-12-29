class RemoveColumnsFromCalls < ActiveRecord::Migration[7.0]
  def change
    remove_column :calls, :title
  end
end
