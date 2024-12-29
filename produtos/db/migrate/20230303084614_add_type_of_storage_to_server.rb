class AddTypeOfStorageToServer < ActiveRecord::Migration[7.0]
  def change
    add_column :servers, :type_of_storage, :integer
  end
end
