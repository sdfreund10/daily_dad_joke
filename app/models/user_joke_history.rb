# frozen_string_literal: true

class UserJokeHistory < ApplicationRecord
  validates :user_id, uniqueness: { scope: [:joke_id] }
  belongs_to :user
  belongs_to :joke
end
