class Comment < ApplicationRecord
  belongs_to :post
  belongs_to :user

  validates :body, presence: true,
            length: { minimum: 5 }

  default_scope { self.order('updated_at DESC') }

  after_save :send_favorite_emails

  private
  def send_favorite_emails
    self.post.favorites.each do |favorite|
      FavoriteMailer.new_comment(favorite.user, post, self).deliver_now
    end
  end
  # both favorite (model) and comment (model) belongs_to  a  post   & a  user
  # self (comment) is the comment subject (in question, the comment that is being saved)
  # self.post (comment's post) is the post the comment subject belongs to
  # favorite.user is the user this favorite subject belongs to (or the favorite's owner)
  # email_users_who_favorited_comment

end
