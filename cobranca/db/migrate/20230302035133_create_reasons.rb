class CreateReasons < ActiveRecord::Migration[7.0]
  def change
    create_table :reasons do |t|
      t.integer :code
      t.string :description

      t.timestamps
    end
  end
end
