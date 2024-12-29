class AddColumnsReferencesToCalls < ActiveRecord::Migration[7.0]
  def change
    add_reference :calls, :call_category, null: false, foreign_key: true
    add_reference :calls, :order, foreign_key: true
  end
end
