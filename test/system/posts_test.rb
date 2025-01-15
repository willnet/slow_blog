require "application_system_test_case"

class PostsTest < ApplicationSystemTestCase
  test "visiting a blog entry and the blog title linked to the post is displayed" do
    visit root_path
    click_on "Hello World!"
    assert_selector "h2", text: "Slow Blog"
  end

  test "visiting my blog entry and edit and destroy button are displayed" do
    sign_in
    click_on "Hello World!"
    assert_link "Edit this post"
    assert_button "Destroy this post"
  end

  test "destroy my entry" do
    sign_in
    click_on "Hello World!"
    click_on "Destroy this post"
    assert_text "Post was successfully destroyed."
  end

  test "update my entry" do
    sign_in
    click_on "Hello World!"
    click_on "Edit this post"
    fill_in "Title", with: "GoodBye World!!"
    fill_in "Body", with: "Trying to update."
    click_on "Update Post"
    assert_text "Post was successfully updated."
  end
end
