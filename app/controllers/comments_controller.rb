class CommentsController < ApplicationController
  before_action :require_sign_in  # 1st
  before_action :authorize_user, only: [:destroy]  # 2nd

  def create
    @comment = @commentable.comments.new(comment_params)
    @comment.user = current_user

    if @comment.save
      flash[:notice] = "Your comment was saved successfully!"
    else
      flash[:error] = "There was an error saving your comment. Please try again."
    end

    if @commentable.is_a? Topic
      redirect_to @commentable # topic show page
    elsif @commentable.is_a? Post
      redirect_to [@commentable.topic, @commentable] # post show page
    end
  end

  def destroy
    #@comment = @commentable.comments.find(params[:id])
    @comment.destroy
    flash[:notice] = "Your comment was deleted."

    if @commentable.is_a? Topic
      redirect_to @commentable
    elsif @commentable.is_a? Post
      redirect_to [@commentable.topic, @commentable]
    end
  end

  private
  def comment_params
    params.require(:comment).permit(:body)
  end

  def authorize_user
    if params[:topic_id]
      @commentable = Topic.find(params[:topic_id])
      @comment = @commentable.comments.find(params[:id])
    elsif params[:post_id]
      @commentable = Post.find(params[:post_id])
      @comment = @commentable.comments.find(params[:id])
    end
    unless current_user && (current_user == @comment.user || current_user.admin?)
      flash[:alert] = "You do not have permission to delete a comment."
      if @commentable.is_a? Topic
        redirect_to @commentable # topic show page
      elsif @commentable.is_a? Post
        redirect_to [@commentable.topic, @commentable]  # post show page
      end
    end
  end

end
