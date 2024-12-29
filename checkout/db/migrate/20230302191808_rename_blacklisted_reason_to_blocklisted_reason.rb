class RenameBlacklistedReasonToBlocklistedReason < ActiveRecord::Migration[7.0]
  def change
    rename_column(:blacklisted_customers, :blacklisted_reason, :blocklisted_reason)
  end
end
