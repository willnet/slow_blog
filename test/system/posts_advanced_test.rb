require "application_system_test_case"

class PostsAdvancedTest < ApplicationSystemTestCase
  test "create a new post with all fields" do
    sign_in
    click_on "New Post"

    fill_in "Title", with: "My Awesome Post"
    fill_in "Body", with: "This is the content of my awesome post."
    select "Published", from: "Status"
    fill_in "Tags (comma separated)", with: "Ruby, Rails, newtag#{Time.current.to_i}"

    click_on "Create Post"

    assert_text "Post was successfully created."
    assert_text "My Awesome Post"
    assert_text "This is the content of my awesome post."
    # Verify tags were created and associated
    post = Post.find_by(title: "My Awesome Post")
    assert_equal 3, post.tags.count
    assert_includes post.tags.pluck(:name), "Ruby"
    assert_includes post.tags.pluck(:name), "Rails"
  end

  test "create a new post as unpublished" do
    sign_in
    click_on "New Post"

    fill_in "Title", with: "Draft Post"
    fill_in "Body", with: "This is a draft that should not be public."
    select "Unpublished", from: "Status"
    fill_in "Tags (comma separated)", with: "draft#{Time.current.to_i}, work-in-progress"

    click_on "Create Post"

    assert_text "Post was successfully created."
    assert_text "Draft Post"
    # Verify tags were created and associated even for unpublished posts
    post = Post.find_by(title: "Draft Post")
    assert_equal 2, post.tags.count
    assert_includes post.tags.pluck(:name), "work-in-progress"
  end

  test "validation errors are displayed when creating invalid post" do
    sign_in
    click_on "New Post"

    # Submit without filling required fields
    click_on "Create Post"

    assert_text "prohibited this post from being saved"
  end

  test "view user posts list" do
    visit user_posts_path(users(:willnet))

    assert_selector "h1", text: "willnet's blog"
    assert_text "Hello World!"
  end

  test "unpublished posts are not visible to other users" do
    sign_in(email: "maeshima@example.com", password: "password")

    # Check that unpublished post is not visible to other user
    visit user_posts_path(users(:willnet))
    assert_no_text "Secret Post"
  end

  test "unpublished posts are not visible to unauthenticated users" do
    visit post_path(posts(:three))
    # In development/test, Rails shows the error page
    # We should not see the post content
    assert_no_text "Secret Post"
    assert_no_text "This is a secret post."
  end

  test "view count increments when viewing a post" do
    visit root_path

    post = posts(:one)
    old_count = post.view_count
    click_on "Hello World!"

    assert_text "willnet's blog"
    assert_equal old_count + 1, post.reload.view_count
  end

  test "pagination works on user posts page" do
    visit user_posts_path(users(:willnet))

    # Should see only 5 posts per page (willnet has 7 published posts total)
    assert_selector "article", count: 5

    # Should have pagination controls
    assert_text "Next Page"
    click_on "Next Page"

    # Should see remaining posts on second page
    assert_selector "article", count: 2
  end

  test "user can only edit and destroy their own posts" do
    sign_in
    visit user_posts_path(users(:maeshima))

    # Click on maeshima's post
    click_on "MyString"

    # Should not see edit/destroy buttons
    assert_no_link "Edit this post"
    assert_no_button "Destroy this post"
  end
end
