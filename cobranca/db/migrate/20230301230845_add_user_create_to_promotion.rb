class AddUserCreateToPromotion < ActiveRecord::Migration[7.0]
  def change
    add_column :promotions, :user_create, :integer
    add_column :promotions, :user_aprove, :integer
  end
end
