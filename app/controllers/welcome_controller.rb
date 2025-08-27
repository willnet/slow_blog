class WelcomeController < ApplicationController
  allow_unauthenticated_access

  def index
    @page = Page.new(params: params, relation: Post)
    @posts = Post.published.order(view_count: :desc).limit(5).offset(@page.offset)
    @popular_tags = Tag.joins(:posts)
                      .where(posts: { status: :published })
                      .group("tags.id")
                      .order("COUNT(posts.id) DESC")
                      .limit(10)
  end
end
