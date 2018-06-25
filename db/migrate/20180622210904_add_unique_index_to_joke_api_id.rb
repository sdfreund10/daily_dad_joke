class AddUniqueIndexToJokeApiId < ActiveRecord::Migration[5.1]
  def change
    add_index :jokes, :api_id, unique: true
  end
end
