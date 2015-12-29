require "sauce_whisk"

module Sauce
  # Overwrite minitest's after_teardown method as their docs suggest
  def after_teardown
    if Capybara.current_session
  
      # Selenium based sessions have unique IDs.  These are the same as
      # the Sauce Labs job ID and are needed for interacting with the
      # REST API.  These are only present for Selenium sessions, so if
      # you're mixing drivers you might need some sort of check here
      # (or ideally, don't mix in the Sauce module for those tests)
      @session_id = Capybara.current_session.driver.browser.session_id
      
      # Capybara cleans up the session but re-uses the browser for each test.
      # Sauce Labs recommends using a fresh Sauce Labs session every test, so
      # we have to clear out the sessions and close them down
      Capybara.reset_sessions!
      Capybara.current_session.driver.quit
      
      begin
        # Sauce Whisk is the REST API wrapper gem. We use it to
        # update the name and success status of the test after it's
        # finished.
        job = SauceWhisk::Job.new({:id => @session_id})

        # The passed? and name methods are Minitest methods.  You could
        # run the name through another method to, say, remove
        # underscores and replace them with spaces if you wanted
        job.passed = passed?
        job.name = name
        job.save
      rescue
        # We're doing nothing in case of REST API errors.  You might
        # want to take some action here instead.
      end
    end
  end
end
