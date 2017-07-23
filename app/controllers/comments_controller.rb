class CommentsController < ApplicationController
  before_action :require_sign_in
  before_action :authorize_user, only: [:destroy]

  def create
    @post = Post.find(params[:post_id])
    @comment = @post.comments.new(comment_params)
    # @comment = @post.comments.new(body: params[:comment][:body], user_id: current_user.id) # OK
    @comment.user = current_user
    if @comment.save
      flash[:notice] = "Comment saved successfully!"
      redirect_to [@post.topic, @post] # post show page
    else
      flash[:alert] = "Comment failed to save."
      redirect_to [@post.topic, @post] # post show page
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