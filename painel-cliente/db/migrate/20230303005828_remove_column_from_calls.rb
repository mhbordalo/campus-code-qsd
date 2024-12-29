class RemoveColumnFromCalls < ActiveRecord::Migration[7.0]
  def change
    remove_column :calls, :order_id, :string
  end
end
