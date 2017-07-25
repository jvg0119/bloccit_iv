class CommentsController < ApplicationController
  before_action :require_sign_in
  before_action :authorize_user, only: [:destroy]

  def create
    # you could also use an if statement instead of the separate Topics::CommentsController
    # if params[:topic_id]
    #   @commentable = Topic.find(params[:topic_id])
    # else
    #    @commentable = Post.find(params[:post_id])
    #  end

# this would also work but the create! could crash the app if there is a validations error
# w/o the ! it won't make the association w/ the topic; it will not save the Commenting interface
#  if  @comment = @commentable.comments.create!(body: params[:comment][:body], user: current_user)

    @comment = @commentable.comments.create(body: params[:comment][:body], user: current_user)
    if @comment.save
      flash[:notice] = "Comment saved successfully!"
    else
      flash[:alert] = "Comment failed to save."
    end

    if @commentible.is_a? Topic
      redirect_to [@commentable, @comment]
      # redirect_to @commentable
    else
      redirect_to @commentable    # to topics show page
      #redirect_to [@commentable, @comment]
    end

#      flash[:notice] = "Comment saved successfully!"
#      redirect_to (@commentable)

      # redirect_to @commentable  # topic or post show page
#    else
#      flash[:alert] = "Comment failed to save."
#      redirect_to @commentable#[@commentable, @comment]
      # redirect_to [@post.topic, @post] # post show page
#    end
  end

  def destroy
    if @comment.destroy
      flash[:notice] = "Comment was deleted successfully."
      redirect_to @commentable # topic or post show page
      #redirect_to [@post.topic, @post] # post show page
    else
      flash[:alert] = "Comment couldn't be deleted. Please try again."
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
  #  post = Post.find(params[:post_id])
  # don't know why the Topics::CommentsController does not work for the destroy action
    if params[:topic_id]
      @commentable = Topic.find(params[:topic_id])
    else
      params[:post_id]
        @commentable = Post.find(params[:post_id])
    end
    @comment = @commentable.comments.find(params[:id])
    unless current_user == @comment.user || current_user.admin?
      flash[:alert] = "You do not have permission to delete a comment. ***"
      redirect_to [post.topic, post] # post show page
    end

    # post = Post.find(params[:post_id])
    # comment = post.comments.find(params[:id])
    # unless current_user == comment.user || current_user.admin?
    #   flash[:alert] = "You do not have permission to delete a comment. ***"
    #   redirect_to [post.topic, post] # post show page
    # end
  end


end
