class RemoveColumnFromBlacklistedCustomers < ActiveRecord::Migration[7.0]
  def change
    remove_column :blacklisted_customers, :blacklisted, :string
    change_column_null :blacklisted_customers, :blacklisted_reason, false
  end
end
