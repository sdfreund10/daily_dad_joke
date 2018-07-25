ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../config/environment', __dir__)
require 'rails/test_help'
require 'webmock/minitest'
WebMock.disable_net_connect!(allow_localhost: true)
Dir[Rails.root.join('test', 'test_helpers', '*.rb')].each { |f| load f }
ENV['PHONE_NUMBER'] = '+0123456789'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  Capybara.register_driver(:headless_chrome) do |app|
    capabilities = Selenium::WebDriver::Remote::Capabilities.chrome(
      chromeOptions: { args: %w(no-sandbox headless disable-gpu) }
    )

    Capybara::Selenium::Driver.new(
      app,
      browser: :chrome,
      desired_capabilities: capabilities
    )
  end
end
