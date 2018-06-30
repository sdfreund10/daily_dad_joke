# frozen_string_literal: true

class User < ApplicationRecord
  validates_format_of :phone_number, with: /\A\d{10}\Z/
  validates_format_of :email, with: URI::MailTo::EMAIL_REGEXP
  validates_uniqueness_of :phone_number, scope: :email
  before_validation :reformat_phone_number
  validates_inclusion_of %i[
    monday tuesday wednesday thursday friday saturday sunday
  ], in: [true, false]
  has_many :user_joke_histories, dependent: :delete_all

  def formatted_phone_number
    "+1#{phone_number}"
  end

  private

  def reformat_phone_number
    return if phone_number.nil?
    self.phone_number = phone_number.tr('() -', '')
  end
end
