class AddNetworks < ActiveRecord::Migration[5.2]
  def change
    create_table :networks do |t|
      t.string :name

      t.timestamps
    end

    add_reference :users, :network
    add_reference :rides, :network
  end
end
