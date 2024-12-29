class AddProductsToPromotion < ActiveRecord::Migration[7.0]
  def change
    add_column :promotions, :products, :text
  end
end
