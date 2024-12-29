class ChageDataTypeForApproveTransactionNumber < ActiveRecord::Migration[7.0]
  def change
    change_column :charges, :approve_transaction_number, :string
  end
end
