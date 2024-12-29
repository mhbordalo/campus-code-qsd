class CreatePeriodicities < ActiveRecord::Migration[7.0]
  def change
    create_table :periodicities do |t|
      t.string :name
      t.integer :deadline

      t.timestamps
    end
  end
end
