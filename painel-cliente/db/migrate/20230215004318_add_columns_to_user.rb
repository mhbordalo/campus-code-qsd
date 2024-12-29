class AddColumnsToUser < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :identification, :integer
    add_column :users, :address, :string
    add_column :users, :zip_code, :string
    add_column :users, :city, :string
    add_column :users, :state, :string
    add_column :users, :phone_number, :string
    add_column :users, :birthdate, :date
    add_column :users, :name, :string
    add_column :users, :corporate_name, :string
    add_column :users, :status, :integer, default: 0
  end
end
