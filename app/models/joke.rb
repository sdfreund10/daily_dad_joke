class Joke < ApplicationRecord
  validates :api_id, uniqueness: true
  has_many :user_joke_histories, dependent: :delete_all
end
