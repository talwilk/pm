module FeatureHelpers
  include Warden::Test::Helpers
  Warden.test_mode!

  def set_cookie(k, v)
    case Capybara.current_session.driver
      when Capybara::Poltergeist::Driver
        page.driver.set_cookie(k,v)
      when Capybara::RackTest::Driver
        page.driver.browser.clear_cookies
        page.driver.browser.set_cookie "#{k}=#{v}"
      when Capybara::Selenium::Driver
        page.driver.browser.manage.add_cookie(:name => k, :value => v)
      else
        raise "No cookie-setter implemented for driver: #{Capybara.current_session.driver.class.name}"
    end
  end

  def sign_in(user)
    login_as(user, :scope => user.class.to_s.underscore.to_sym)
  end
end
