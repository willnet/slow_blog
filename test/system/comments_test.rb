require "application_system_test_case"

class CommentsTest < ApplicationSystemTestCase
  test "Create a new comment" do
    sign_in
    click_on "Hello World!"
    fill_in "comment_body", with: "This is a comment."
    click_on "Create Comment"
    assert_text "Comment was successfully created."
    assert_text "This is a comment."
  end

  test "Update my comment" do
    sign_in
    click_on "Hello World!"
    within "#comment_#{comments(:one).id}" do
      click_on "Edit"
      fill_in "comment_body", with: "This is an updated comment."
      click_on "Update Comment"
      assert_text "This is an updated comment."
    end
  end

  test "Destroy my comment" do
    sign_in
    click_on "Hello World!"
    within "#comment_#{comments(:one).id}" do
      accept_confirm do
        click_on "Destroy"
      end
    end
    assert_no_text "This is a comment."
  end
end
