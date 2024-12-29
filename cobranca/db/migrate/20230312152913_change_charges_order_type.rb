class ChangeChargesOrderType < ActiveRecord::Migration[7.0]
  def change
    reversible do |dir|
      change_table :charges do |t|
        dir.up   { t.change :order, :string }
        dir.down { t.change :order, :integer }
      end
    end
  end
end
