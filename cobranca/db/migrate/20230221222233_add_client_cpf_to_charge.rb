class AddClientCpfToCharge < ActiveRecord::Migration[7.0]
  def change
    add_column :charges, :client_cpf, :string
    add_column :charges, :order_id, :integer
    add_column :charges, :final_value, :decimal
  end
end
