require "application_system_test_case"
# TODO: ログ取る

class WelcomeTest < ApplicationSystemTestCase
  test "Sign In and Sign Out" do
    visit root_path
    click_on "Sign In"
    fill_in "email_address", with: "willnet@example.com"
    fill_in "password", with: "password"
    within "main" do
      click_on "Sign in"
    end

    within "header" do
      assert_selector "a", text: "Sign Out"
    end

    sign_out

    assert_selector "a", text: "Sign In"
  end
end
