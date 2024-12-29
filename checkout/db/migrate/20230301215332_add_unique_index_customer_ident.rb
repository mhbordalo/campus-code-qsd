class AddUniqueIndexCustomerIdent < ActiveRecord::Migration[7.0]
  def change
    add_index :blacklisted_customers, :doc_ident, unique: true
  end
end
