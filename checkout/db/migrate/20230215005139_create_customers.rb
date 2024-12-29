class CreateCustomers < ActiveRecord::Migration[7.0]
  def change
    create_table :customers do |t|
      t.string :doc_ident, null: false
      t.boolean :blacklisted, default: false
      t.string :blacklisted_reason, null: true

      t.timestamps
    end
  end
end
