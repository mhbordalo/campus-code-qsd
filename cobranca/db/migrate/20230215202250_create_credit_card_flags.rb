class CreateCreditCardFlags < ActiveRecord::Migration[7.0]
  def change
    create_table :credit_card_flags do |t|
      t.string :credit_card_flag
      t.string :name
      t.integer :rate
      t.integer :maximum_value
      t.integer :maximum_number_of_installments
      t.boolean :cash_purchase_discount
      t.integer :status

      t.timestamps
    end
  end
end
