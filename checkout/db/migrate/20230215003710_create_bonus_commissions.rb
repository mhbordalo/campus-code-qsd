class CreateBonusCommissions < ActiveRecord::Migration[7.0]
  def change
    create_table :bonus_commissions do |t|
      t.string :description, null: false
      t.datetime :start_date, null: false
      t.datetime :end_date, null: false
      t.decimal :commission_perc, precision: 8, scale: 2
      t.decimal :amount_limit, precision: 8, scale: 2
      t.boolean :active, default: true

      t.timestamps
    end
  end
end
