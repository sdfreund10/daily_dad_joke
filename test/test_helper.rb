ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'webmock/minitest'
WebMock.disable_net_connect!(allow_localhost: true)
Dir[Rails.root.join("test", "test_helpers", "*.rb")].each { |f| load f }
ENV['PHONE_NUMBER'] = '+0123456789'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...
end
