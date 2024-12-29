class ChangeChargeCollumns < ActiveRecord::Migration[7.0]
  def change
    add_reference :charges, :reasons, foreign_key: true
    remove_column :charges, :disapproved_code, :integer
    remove_column :charges, :disapproved_reason, :string
    remove_column :charges, :credit_card_flag_id, :integer
    rename_column :charges, :order_id, :order
    add_column :charges, :creditcard_token, :string
  end
end

