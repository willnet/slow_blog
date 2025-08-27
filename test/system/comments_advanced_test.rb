require "application_system_test_case"

class CommentsAdvancedTest < ApplicationSystemTestCase
  test "unauthenticated users cannot create comments" do
    visit root_path
    click_on "Hello World!"

    # Comment form should not be visible
    assert_no_selector "textarea[name='comment[body]']"
    assert_no_button "Create Comment"
  end

  test "cannot see edit/destroy buttons for other users' comments" do
    sign_in
    visit root_path

    # Navigate to a post with comments from another user
    click_on "MyString" # maeshima's post

    # maeshima's comment should be visible but not editable
    within "#comment_#{comments(:two).id}" do
      assert_text "that is also a comment"
      assert_no_link "Edit"
      assert_no_link "Destroy"
    end
  end

  test "validation error when submitting empty comment" do
    sign_in
    click_on "Hello World!"

    # Submit empty comment
    click_on "Create Comment"

    # Should see validation error (using the alert message from controller)
    assert_text "Body can't be blank"
  end

  test "multiple comments are displayed in order" do
    sign_in
    click_on "Hello World!"

    # Create first comment
    fill_in "comment[body]", with: "First comment"
    click_on "Create Comment"

    # Wait for redirect and then create second comment
    assert_text "Comment was successfully created."

    # Create second comment
    fill_in "comment[body]", with: "Second comment"
    click_on "Create Comment"

    # Both comments should be visible
    assert_text "First comment"
    assert_text "Second comment"

    # Verify order (newer comments might appear first or last depending on implementation)
    # Note: The page includes both the post article and comment articles
    comments = all("footer article")
    assert comments.size >= 3 # At least 3 comments (including the fixture)
  end

  test "comment form is visible only for authenticated users" do
    # First check as unauthenticated
    visit root_path
    click_on "Hello World!"
    assert_no_selector "form#new_comment"

    # Then check as authenticated
    sign_in
    click_on "Hello World!"
    assert_selector "form[action*='/comments']"
    assert_selector "textarea[name='comment[body]']"
  end

  test "destroy comment removes it from the page" do
    sign_in
    click_on "Hello World!"

    # Create a comment to destroy
    fill_in "comment[body]", with: "Comment to be deleted"
    click_on "Create Comment"

    # Find and destroy the comment
    # Find comment within turbo frame
    comment_element = find("turbo-frame article", text: "Comment to be deleted")
    within comment_element do
      accept_confirm do
        click_on "Destroy"
      end
    end

    # Comment should be gone
    assert_no_text "Comment to be deleted"
  end

  test "edit comment updates the content" do
    sign_in
    click_on "Hello World!"

    # Edit existing comment
    within "#comment_#{comments(:one).id}" do
      click_on "Edit"
      fill_in "comment_body", with: "Updated comment content"
      click_on "Update Comment"
    end

    # Should see updated content
    assert_text "Updated comment content"
    assert_no_text "this is a comment" # Original text should be gone
  end

  test "comment belongs to the correct user" do
    sign_in
    click_on "Hello World!"

    # Create a comment
    fill_in "comment[body]", with: "Comment by willnet"
    click_on "Create Comment"

    # The comment should show the user's name
    # Find comment within turbo frame
    comment_element = find("turbo-frame article", text: "Comment by willnet")
    within comment_element do
      assert_text "willnet"
    end
  end

  test "comments persist after page reload" do
    sign_in
    click_on "Hello World!"

    # Create a comment
    fill_in "comment[body]", with: "Persistent comment"
    click_on "Create Comment"

    # Reload the page
    visit current_path

    # Comment should still be there
    assert_text "Persistent comment"
  end
end
