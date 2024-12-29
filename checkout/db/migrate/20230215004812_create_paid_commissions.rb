class CreatePaidCommissions < ActiveRecord::Migration[7.0]
  def change
    create_table :paid_commissions do |t|
      t.datetime :paid_at, null: false
      t.decimal :amount, null: false, precision: 8, scale: 2
      t.references :bonus_commission, null: false, foreign_key: true

      t.timestamps
    end
  end
end
