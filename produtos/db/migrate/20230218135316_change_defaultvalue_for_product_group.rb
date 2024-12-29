class ChangeDefaultvalueForProductGroup < ActiveRecord::Migration[7.0]
  def change
    change_column_default :product_groups, :status, from: 0, to: 5
  end
end
