class ChangeColumnTypeCreditCard < ActiveRecord::Migration[7.0]
  def change
    change_column :credit_cards, :validate_month, :string
    change_column :credit_cards, :validate_year, :string
    change_column :credit_cards, :cvv, :string
  end
end
