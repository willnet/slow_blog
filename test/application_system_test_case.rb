require "test_helper"
require "capybara/playwright"

Capybara.default_max_wait_time = 5

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  driven_by :playwright, using: :chromium, screen_size: [ 1400, 1400 ], options: {
    headless: true
  }

  def sign_in(email: "willnet@example.com", password: "password")
    visit root_path
    click_on "Sign In"
    fill_in "email_address", with: email
    fill_in "password", with: password
    within "main" do
      click_on "Sign in"
    end
    assert_selector "a", text: "Sign Out"
  end

  def sign_out
    within "header" do
      assert_selector "a", text: "Sign Out"
      sleep 0.5
      click_on "Sign Out"
    end
    assert_selector "h1", text: "Sign in"
  end
end
