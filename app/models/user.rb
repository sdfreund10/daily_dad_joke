class User < ApplicationRecord
  validates_format_of :phone_number, with: /\A\d{9}\Z/
end
