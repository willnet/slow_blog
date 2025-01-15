class PostsController < ApplicationController
  allow_unauthenticated_access only: %i[ index show ]

  # GET /posts
  def index
    @user = User.find(params[:user_id])
    @page = Page.new(params: params, relation: Post)
    @posts = @user.posts.order(created_at: :desc).limit(20).offset(@page.offset)
  end

  # GET /posts/1
  def show
    @post = Post.find(params.expect(:id))
  end

  # GET /posts/new
  def new
    @post = Post.new
  end

  # GET /posts/1/edit
  def edit
    @post = Current.user.posts.find(params[:id])
  end

  # POST /posts
  def create
    @post = Current.user.posts.build(post_params)

    if @post.save
      redirect_to @post, notice: "Post was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /posts/1
  def update
    @post = Current.user.posts.find(params[:id])
    if @post.update(post_params)
      redirect_to @post, notice: "Post was successfully updated.", status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /posts/1
  def destroy
    post = Current.user.posts.find(params[:id])
    post.destroy!
    redirect_to user_posts_path(Current.user), notice: "Post was successfully destroyed.", status: :see_other
  end

  private
    # Only allow a list of trusted parameters through.
    def post_params
      params.expect(post: [ :title, :body ])
    end
end
