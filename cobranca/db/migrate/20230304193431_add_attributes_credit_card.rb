class AddAttributesCreditCard < ActiveRecord::Migration[7.0]
  def change
    add_column :credit_cards, :alias, :string
    add_reference :credit_cards, :credit_card_flag, foreign_key: true
  end
end
