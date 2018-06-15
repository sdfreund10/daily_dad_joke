class CreateJokes < ActiveRecord::Migration[5.1]
  def change
    create_table :jokes do |t|
      t.string :api_id, null: false
      t.string :joke

      t.timestamps
    end
  end
end
