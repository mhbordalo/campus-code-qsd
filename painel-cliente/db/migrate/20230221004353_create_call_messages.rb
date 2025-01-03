class CreateCallMessages < ActiveRecord::Migration[7.0]
  def change
    create_table :call_messages do |t|
      t.references :call, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.text :message

      t.timestamps
    end
  end
end
