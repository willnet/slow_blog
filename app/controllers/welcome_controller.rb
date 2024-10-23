class WelcomeController < ApplicationController
  allow_unauthenticated_access

  def index
    @page = Page.new(params: params, relation: Post)
    @posts = Post.order(created_at: :desc).limit(20).offset(@page.offset)
  end
end
