class AddProductGroupToServers < ActiveRecord::Migration[7.0]
  def change
    add_reference :servers, :product_group, null: false, foreign_key: true
  end
end
