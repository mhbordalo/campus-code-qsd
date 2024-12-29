class AddColumnToCalls < ActiveRecord::Migration[7.0]
  def change
    add_reference :calls, :product, null: false, foreign_key: true
  end
end
