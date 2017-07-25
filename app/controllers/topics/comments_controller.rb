class Topics::CommentsController < CommentsController
#  before_action :require_sign_in
  before_action :set_commentable


  private
  def set_commentable
    @commentable = Topic.find(params[:topic_id])
  end

end
