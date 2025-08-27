require "application_system_test_case"

class PostsTest < ApplicationSystemTestCase
  test "visiting a blog entry and the blog title linked to the post is displayed" do
    visit root_path
    click_on "Hello World!"
    assert_selector "h1", text: "willnet's blog"
  end

  test "visiting my blog entry and edit and destroy button are displayed" do
    sign_in
    click_on "Hello World!"
    assert_button "Edit this post"
    assert_button "Destroy this post"
  end

  test "destroy my entry" do
    sign_in
    click_on "Hello World!"
    accept_confirm do
      click_on "Destroy this post"
    end
    assert_text "Post was successfully destroyed."
  end

  test "update my entry" do
    sign_in
    click_on "Hello World!"
    click_on "Edit this post"
    fill_in "Title", with: "GoodBye World!!"
    fill_in "Body", with: "Trying to update."
    fill_in "Tags (comma separated)", with: "updated#{Time.current.to_i}, goodbye, testupdate"
    click_on "Update Post"
    assert_text "Post was successfully updated."

    # Verify tags were updated
    post = Post.find_by(title: "GoodBye World!!")
    assert_equal 3, post.tags.count
    assert_includes post.tags.pluck(:name), "goodbye"
    assert_includes post.tags.pluck(:name), "testupdate"
  end
end
