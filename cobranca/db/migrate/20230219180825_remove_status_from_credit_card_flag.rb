class RemoveStatusFromCreditCardFlag < ActiveRecord::Migration[7.0]
  def change
    remove_column :credit_card_flags, :status, :integer
  end
end
