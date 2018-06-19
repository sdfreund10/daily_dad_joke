class User < ApplicationRecord
  validates_format_of :phone_number, with: /\A\d{10}\Z/
  validates_format_of :email, with: URI::MailTo::EMAIL_REGEXP
  validates_uniqueness_of :phone_number, scope: :email
  before_validation :reformat_phone_number

  private

  def reformat_phone_number
    return if phone_number.nil?
    self.phone_number = phone_number.tr("() -", "")
  end
end
