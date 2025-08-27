class PostsController < ApplicationController
  allow_unauthenticated_access only: %i[ index show ]

  def index
    @user = User.find(params[:user_id])

    posts_scope = @user.posts.eager_load(:comments)
    posts_scope = posts_scope.published unless Current.user == @user

    # Filter by tag if specified
    if params[:tag_id].present?
      posts_scope = posts_scope.joins(:tags).where(tags: { id: params[:tag_id] })
    end

    @page = Page.new(params: params, relation: posts_scope)
    @posts = posts_scope.order(created_at: :desc).limit(@page.per_page).offset(@page.offset)
    @all_user_tags = Tag.joins(:posts).where(posts: { user: @user }).distinct
  end

  def show
    @post = Post.find(params.expect(:id))

    unless @post.published? || @post.created_by?(Current.user)
      raise ActiveRecord::RecordNotFound
    end

    @post.increment!(:view_count)
  end

  def new
    @post = Post.new
  end

  def edit
    @post = Current.user.posts.find(params[:id])
  end

  def create
    @post = Current.user.posts.build(post_params)

    if @post.save
      redirect_to @post, notice: "Post was successfully created.", status: :see_other
    else
      render :new, status: :unprocessable_content
    end
  end

  def update
    @post = Current.user.posts.find(params[:id])
    if @post.update(post_params)
      redirect_to @post, notice: "Post was successfully updated.", status: :see_other
    else
      render :edit, status: :unprocessable_content
    end
  end

  def destroy
    post = Current.user.posts.find(params[:id])
    post.destroy!
    redirect_to user_posts_path(Current.user), notice: "Post was successfully destroyed.", status: :see_other
  end

  private
    def post_params
      params.expect(post: [ :title, :body, :status, :tag_names ])
    end
end
