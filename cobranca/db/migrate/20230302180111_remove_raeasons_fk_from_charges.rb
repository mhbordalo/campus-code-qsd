class RemoveRaeasonsFkFromCharges < ActiveRecord::Migration[7.0]
  def change
    remove_foreign_key :charges, column: :reasons_id
  end
end
