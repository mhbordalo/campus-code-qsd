class AddIndexToCreditCard < ActiveRecord::Migration[7.0]
  def change
    add_index :credit_cards, :card_number, unique: true
  end
end
