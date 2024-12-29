class CreateCreditCars < ActiveRecord::Migration[7.0]
  def change
    create_table :credit_cars do |t|
      t.string :card_number
      t.integer :validate_month
      t.integer :validate_year
      t.integer :cvv
      t.string :owner_name
      t.string :owner_doc

      t.timestamps
    end
  end
end
