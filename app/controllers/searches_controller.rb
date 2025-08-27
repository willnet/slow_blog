class SearchesController < ApplicationController
  allow_unauthenticated_access

  def index
    @tag = Tag.find_by(name: params[:tag])

    if @tag
      @page = Page.new(params: params, relation: @tag.posts.published)
      @posts = @tag.posts.published.order(view_count: :desc).limit(5).offset(@page.offset)
    else
      @page = Page.new(params: params, relation: Post.none)
      @posts = Post.none
    end
  end
end
