class CreateServers < ActiveRecord::Migration[7.0]
  def change
    create_table :servers do |t|
      t.string :code
      t.string :operational_system
      t.string :os_version
      t.integer :number_of_cpus
      t.integer :storage_capacity
      t.string :type_of_storage
      t.integer :amount_of_ram
      t.integer :max_installations

      t.timestamps
    end
  end
end
