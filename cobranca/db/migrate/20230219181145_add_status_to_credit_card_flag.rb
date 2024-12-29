class AddStatusToCreditCardFlag < ActiveRecord::Migration[7.0]
  def change
    add_column :credit_card_flags, :status, :integer, default: 0
  end
end
