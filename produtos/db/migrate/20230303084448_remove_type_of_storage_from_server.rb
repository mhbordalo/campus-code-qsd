class RemoveTypeOfStorageFromServer < ActiveRecord::Migration[7.0]
  def change
    remove_column :servers, :type_of_storage, :string
  end
end
