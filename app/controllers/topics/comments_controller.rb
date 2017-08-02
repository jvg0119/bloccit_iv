class Topics::CommentsController < CommentsController
  before_action :set_commentable # 3rd
  #before_action :authorize_user, only: [:destroy]

  private
  def set_commentable
    @commentable = Topic.find(params[:topic_id])
  end

  # def authorize_user
  #   #@post = Post.find(params[:post_id])
  #   @comment = @commentable.comments.find(params[:id])
  # #  raise
  #   unless current_user == @comment.user || current_user.admin?
  #     flash[:alert] = "You do not have permission to delete a comment."
  #     redirect_to [@commentable.topic, @commentable] # post show
  #     #redirect_to [@post.topic, @post] # post show page
  #   end
  # end

end
