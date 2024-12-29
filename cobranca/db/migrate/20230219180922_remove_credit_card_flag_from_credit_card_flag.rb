class RemoveCreditCardFlagFromCreditCardFlag < ActiveRecord::Migration[7.0]
  def change
    remove_column :credit_card_flags, :credit_card_flag, :string
  end
end
