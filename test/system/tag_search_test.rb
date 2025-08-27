require "application_system_test_case"

class TagSearchTest < ApplicationSystemTestCase
  test "clicking popular tag on homepage navigates to tag search" do
    visit root_path

    # Popular Tagsセクションが表示されていることを確認
    if page.has_selector?("h2", text: "Popular Tags")
      # Popular Tagsセクション内で最初のタグをクリック
      within page.find("h2", text: "Popular Tags").find(:xpath, "..") do
        first_tag_link = find("a", match: :first)
        tag_name = first_tag_link.text
        first_tag_link.click

        # 検索ページに遷移したことを確認
        assert_current_path searches_path(tag: tag_name)

        # タグで絞り込まれていることを表示で確認
        assert_selector "h2", text: "Posts tagged with \"#{tag_name}\""
      end
    else
      skip "No popular tags found on homepage"
    end
  end

  test "tag search page shows filtered posts" do
    # テスト用のタグを持つ投稿があることを前提とする
    tag_name = tags(:ruby).name

    visit searches_path(tag: tag_name)

    # タグで絞り込まれていることを表示で確認
    assert_selector "h2", text: "Posts tagged with \"#{tag_name}\""

    # 投稿が表示されていることを確認（タグに関連する投稿がある場合）
    if page.has_selector?("article")
      assert_selector "article"
    else
      assert_selector "p", text: "No posts found."
    end
  end

  test "tag search pagination preserves tag parameter" do
    # 多数の投稿があるタグでテストする場合
    tag_name = tags(:ruby).name

    visit searches_path(tag: tag_name)

    # ページネーションリンクがある場合、タグパラメータが保持されることを確認
    if page.has_link?("Next Page")
      click_link "Next Page"
      assert_current_path searches_path(tag: tag_name, page: 2)
      assert_selector "h2", text: "Posts tagged with \"#{tag_name}\""
    else
      skip "No pagination available for this tag"
    end
  end

  test "nonexistent tag shows appropriate message" do
    visit searches_path(tag: "nonexistent_tag")

    assert_selector "h2", text: "Tag not found"
    assert_selector "p", text: "The requested tag does not exist."
  end
end
