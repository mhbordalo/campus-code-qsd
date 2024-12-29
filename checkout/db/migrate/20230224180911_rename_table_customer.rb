class RenameTableCustomer < ActiveRecord::Migration[7.0]
  def change
    rename_table :customers, :blacklisted_customers
  end
end
