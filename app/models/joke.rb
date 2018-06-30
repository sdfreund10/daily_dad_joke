# frozen_string_literal: true

class Joke < ApplicationRecord
  validates :api_id, uniqueness: true
  has_many :user_joke_histories, dependent: :delete_all

  def self.upsert_from_api(params)
    record = find_or_initialize_by(api_id: params['id'])
    record.joke = params['joke']
    record.save! if record.changed?
    record
  end
end
