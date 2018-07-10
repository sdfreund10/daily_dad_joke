class RemoveEmailFromUsers < ActiveRecord::Migration[5.1]
  def up
    remove_column :users, :email
    add_index :users, :phone_number, unique: true
  end

  def down
    raise ActiveRecord::IrreversibleMigration,
          "email cannot be automatically added back to users"
  end
end
