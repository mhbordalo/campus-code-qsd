class AddColumnOrder < ActiveRecord::Migration[7.0]
  def change
    add_column :orders, :customer_doc_ident, :string, null: false
  end
end
