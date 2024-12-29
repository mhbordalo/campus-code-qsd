class ChangeColumnChargeStatusToCharge < ActiveRecord::Migration[7.0]
  def change
    change_column :charges, :charge_status, :integer, default: 1
  end
end
