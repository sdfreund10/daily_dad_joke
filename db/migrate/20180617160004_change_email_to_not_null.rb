class ChangeEmailToNotNull < ActiveRecord::Migration[5.1]
  def change
    change_column_null :users, :email, false
    add_index :users, %i(email phone_number)
  end
end
