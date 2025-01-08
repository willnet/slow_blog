require "application_system_test_case"

class WelcomeTest < ApplicationSystemTestCase
  test "visiting the index" do
    visit root_path
    assert_selector "h1", text: "Slow Blog"
  end
end
