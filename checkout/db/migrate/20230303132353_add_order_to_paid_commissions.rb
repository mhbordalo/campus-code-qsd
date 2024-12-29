class AddOrderToPaidCommissions < ActiveRecord::Migration[7.0]
  def change
    add_reference :paid_commissions, :order, null: false, foreign_key: true
  end
end
