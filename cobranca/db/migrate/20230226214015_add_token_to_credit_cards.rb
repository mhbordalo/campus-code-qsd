class AddTokenToCreditCards < ActiveRecord::Migration[7.0]
  def change
    add_column :credit_cards, :token, :string
  end
end
