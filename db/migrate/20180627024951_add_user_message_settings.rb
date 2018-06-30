class AddUserMessageSettings < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :time, :string, default: "9:00", null: false
    add_column :users, :sunday, :boolean, default: true, null: false
    add_column :users, :monday, :boolean, default: true, null: false
    add_column :users, :tuesday, :boolean, default: true, null: false
    add_column :users, :wednesday, :boolean, default: true, null: false
    add_column :users, :thursday, :boolean, default: true, null: false
    add_column :users, :friday, :boolean, default: true, null: false
    add_column :users, :saturday, :boolean, default: true, null: false
  end
end
