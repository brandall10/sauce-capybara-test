# test/support/capybara.rb
# Assuming Capybara needs to be set up from scratch; Otherwise check the 
# Capybara integration gem you're using for help.
# The sauce.rb file is in the same directory here, otherwise update the
# require_relative to fit reality
require "capybara/rails"
require_relative "./sauce"

class ActionDispatch::IntegrationTest
  # Make the Capybara DSL available in IntegrationTest's
  include Capybara::DSL
  include ::Sauce
end

# Assuming your Sauce username and Access Key are environment variable
auth = "#{ENV["SAUCE_USERNAME"]}:#{ENV["SAUCE_ACCESS_KEY"]}"

# The Sauce Labs test endpoint
url = "http://#{auth}@ondemand.saucelabs.com/wd/hub"

caps = Selenium::WebDriver::Remote::Capabilities.edge
caps['platform'] = 'Windows 10'
caps['version'] = '20.10240'

# Capybara lets you create custom drivers, which we're doing here.
# We're basing it off the built-in Capybara Selenium driver.
# All the arguments except `app` are passed to Selenium.
Capybara.register_driver :sauce do |app|
 Capybara::Selenium::Driver.new(app,
                                :browser => :remote, :url => url,
                                :desired_capabilities => caps)
end

# Set Capybara to use Sauce Labs for everything
Capybara.default_driver = :sauce
Capybara.javascript_driver = :sauce
