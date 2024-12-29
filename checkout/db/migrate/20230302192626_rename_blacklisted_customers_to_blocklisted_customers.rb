class RenameBlacklistedCustomersToBlocklistedCustomers < ActiveRecord::Migration[7.0]
  def change
    rename_table :blacklisted_customers, :blocklisted_customers
  end
end
