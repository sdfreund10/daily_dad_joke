# frozen_string_literal: true

class User < ApplicationRecord
  validates_format_of :phone_number, with: /\A\d{10}\Z/
  validates_uniqueness_of :phone_number
  before_validation :reformat_phone_number
  validates_inclusion_of %i[
    monday tuesday wednesday thursday friday saturday sunday
  ], in: [true, false]
  has_many :user_joke_histories, dependent: :delete_all
  after_create :send_confirmation

  def formatted_phone_number
    "+1#{phone_number}"
  end

  private

  def reformat_phone_number
    return if phone_number.nil?
    self.phone_number = phone_number.tr('() -', '')
  end

  def send_confirmation
    Twilio::REST::Client.new(
      ENV['ACCOUNT_SID'], ENV['AUTH_TOKEN']
    ).messages.create(
      from: ENV['PHONE_NUMBER'],
      to: formatted_phone_number,
      body: "Thanks for signing up for Daily Dad Joke. "\
            "You should recieve your first message on the next weekday "\
            "specified during signup :)"
    )
  end
end
