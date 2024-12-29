class CreateCharges < ActiveRecord::Migration[7.0]
  def change
    create_table :charges do |t|
      t.integer :charge_status
      t.integer :approve_transaction_number
      t.integer :disapproved_code
      t.string :disapproved_reason

      t.timestamps
    end
  end
end
