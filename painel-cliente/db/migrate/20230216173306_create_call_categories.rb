class CreateCallCategories < ActiveRecord::Migration[7.0]
  def change
    create_table :call_categories do |t|
      t.string :description

      t.timestamps
    end

    add_index :call_categories, :description, unique: true
  end
end
