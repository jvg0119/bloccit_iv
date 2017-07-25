class CommentsController < ApplicationController
  before_action :require_sign_in
  before_action :authorize_user, only: [:destroy]

  def create
    #@post = Post.find(params[:post_id])
    @comment = @commentable.comments.build(comment_params)
  #  @comment = @topic.comments.new(comment_params)
    # @comment = @post.comments.new(body: params[:comment][:body], user_id: current_user.id) # OK
  #  @comment = Comment.new(comment_params)
    @comment.user = current_user
    #@comment.commentings = @commentable
  #  @comment.topic
  #  @comment.post = @commentable.post

  #raise
    if @comment.save!
    #  @comment.update(params[:topic_id])
      flash[:notice] = "Comment saved successfully!"
  #  raise
  #params[:session][:email]
  #  byebug
  redirect_to @commentable  # [@commentable, @comment]
  #  redirect_to @topic
  #  raise
    #  redirect_to [@post.topic, @post] # post show page
    else
      flash[:alert] = "Comment failed to save."
      redirect_to @commentable#[@commentable, @comment]
      # redirect_to [@post.topic, @post] # post show page
    end
  end

  def destroy
    @post = Post.find(params[:post_id])
    @comment = @post.comments.find(params[:id])
    if @comment.destroy
      flash[:notice] = "Comment was deleted successfully."
      redirect_to [@post.topic, @post] # post show page
    else
      flash[:alert] = "Comment couldn't be deleted. Please try again."
      "did not destroy"
      redirect_to [@post.topic, @post] # post show page
    end
  end

  private
  def comment_params
    #params.require(:comment).permit(:body)
    params.require(:comment).permit(:body)
  end

  # same as below
  # def authorize_user
  #    comment = Comment.find(params[:id])
  #    unless current_user == comment.user || current_user.admin?
  #      flash[:alert] = "You do not have permission to delete a comment."
  #      redirect_to [comment.post.topic, comment.post]
  #    end
  #  end


  def authorize_user
    post = Post.find(params[:post_id])
    comment = post.comments.find(params[:id])
    unless current_user == comment.user || current_user.admin?
      flash[:alert] = "You do not have permission to delete a comment. ***"
      redirect_to [post.topic, post] # post show page
    end
  end


end
