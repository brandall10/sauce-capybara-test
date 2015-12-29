# test/integration/some_test.rb
# Tests don't have to be in integration *or* subclass IntegrationTest
# but for the purposes of this example we are.
require "test_helper"

# Check the comments in the capybara.rb file to see how Sauce is included here
class SomeTest < ::ActionDispatch::IntegrationTest

  test "rendered page contains website layout" do
    visit 'http://google.com'
    assert(page.has_selector?("html>head+body"))
    assert_match(/Google/, page.title)
  end
  
  test "rendered page contains local application layout" do
    visit("http://localhost:3000")
    assert(page.has_selector?("html>head+body"))
    assert_match(/Ruby/, page.title)
  end

end
