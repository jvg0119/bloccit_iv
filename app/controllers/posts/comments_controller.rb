class Posts::CommentsController < CommentsController
#  before_action :require_sign_in
  before_action :set_commentable


  private
  def set_commentable
    # @topic = Topic.find(params[:topic_id])
    # @commentable = @topic.posts.find(params[:post_id])

    @commentable = Post.find(params[:post_id])
  end

end
