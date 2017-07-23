module CommentsHelper

  def user_is_authorized_for_comment?(comment)
    #current_user == comment.user || current_user.admin?  if current_user # works OK
    current_user && (current_user == comment.user || current_user.admin?)
  end

end
