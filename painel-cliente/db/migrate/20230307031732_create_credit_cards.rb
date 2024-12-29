class CreateCreditCards < ActiveRecord::Migration[7.0]
  def change
    create_table :credit_cards do |t|
      t.string :token
      t.string :card_number
      t.string :owner_name
      t.string :credit_card_flag
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
