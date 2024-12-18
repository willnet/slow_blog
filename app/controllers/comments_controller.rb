class CommentsController < ApplicationController
  def edit
    @post = Post.find(params[:post_id])
    @comment = Current.user.comments.find(params.expect(:id))
  end

  def create
    @post = Post.find(params[:post_id])
    @comment = Current.user.comments.build(comment_params.merge(post_id: @post.id))

    if @comment.save
      redirect_to @post, notice: "Comment was successfully created."
    else
      redirect_to @post, notice: "Comment wasn't successfully created."
    end
  end

  def update
    @post = Post.find(params[:post_id])
    @comment = Current.user.comments.find(params[:id])
    if @comment.update(comment_params)
      redirect_to @post, notice: "Comment was successfully updated.", status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    post = Post.find(params[:post_id])
    comment = Current.user.comments.find(params[:id])
    comment.destroy!
    redirect_to post, notice: "Comment was successfully destroyed.", status: :see_other
  end

  private

  def comment_params
    params.expect(comment: [ :body ])
  end
end
