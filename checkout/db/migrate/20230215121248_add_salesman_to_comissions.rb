class AddSalesmanToComissions < ActiveRecord::Migration[7.0]
  def change
    add_reference :paid_commissions, :salesman, foreign_key: { to_table: :users }
  end
end
