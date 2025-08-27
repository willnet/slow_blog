require "test_helper"

class PostsWithTagsTest < ActionDispatch::IntegrationTest
  test "create post with tags" do
    user = users(:willnet)

    post "/session", params: {
      email_address: user.email_address,
      password: "password"
    }

    assert_difference "Post.count", 1 do
      assert_difference "Tag.count", 2 do # assuming 2 new tags
        post "/posts", params: {
          post: {
            title: "Test Post with Tags",
            body: "This is a test post with tags.",
            status: "published",
            tag_names: "testtag#{Time.current.to_i}, anothertag#{Time.current.to_i}"
          }
        }
      end
    end

    assert_redirected_to post_path(Post.last)

    created_post = Post.last
    assert_equal "Test Post with Tags", created_post.title
    assert_equal 2, created_post.tags.count
  end

  test "update post with tags" do
    user = users(:willnet)
    post = posts(:one)

    post "/session", params: {
      email_address: user.email_address,
      password: "password"
    }

    patch "/posts/#{post.id}", params: {
      post: {
        title: post.title,
        body: post.body,
        status: post.status,
        tag_names: "updatedtag#{Time.current.to_i}, newtag#{Time.current.to_i}"
      }
    }

    assert_redirected_to post_path(post)

    post.reload
    assert_equal 2, post.tags.count
  end
end
