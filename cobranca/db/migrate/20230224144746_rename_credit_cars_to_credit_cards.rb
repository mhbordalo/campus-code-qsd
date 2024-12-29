class RenameCreditCarsToCreditCards < ActiveRecord::Migration[7.0]
  def change
    rename_table :credit_cars, :credit_cards
  end
end
