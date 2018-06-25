class CreateUserJokeHistories < ActiveRecord::Migration[5.1]
  def change
    create_table :user_joke_histories do |t|
      t.references :user
      t.references :joke
      t.timestamps
      t.index %i(user_id joke_id), unique: true
    end
  end
end
