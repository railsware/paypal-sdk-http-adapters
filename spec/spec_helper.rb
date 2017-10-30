require "bundler/setup"
require "paypal-sdk-http-adapters"
require 'webmock/rspec'

# configure paypal sdk
PayPal::SDK.configure(
  mode: 'sandbox',
  client_id: 'paypal_client_id',
  client_secret: 'paypal_client_secret'
)

PayPal::SDK.logger.level = Logger::WARN

PayPal::SDK.load_http_adapter :net_http
PayPal::SDK.load_http_adapter :em_http

# configure rspec
RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.before(:each) do
    WebMock.reset!
  end
end
