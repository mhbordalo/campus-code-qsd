class ChangePaidCommissionsBonusToAllowNull < ActiveRecord::Migration[7.0]
  def change
    change_column_null :paid_commissions, :bonus_commission_id, true
  end
end
