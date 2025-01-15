require "application_system_test_case"

class WelcomeTest < ApplicationSystemTestCase
  test "visiting the index" do
    visit root_path
    assert_selector "h1", text: "Slow Blog"
  end

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

    click_on "Sign Out"
    within "header" do
      assert_selector "a", text: "Sign In"
    end
  end
end
