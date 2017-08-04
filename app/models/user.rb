class User < ApplicationRecord
  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :votes, dependent: :destroy
  has_many :favorites, dependent: :destroy

  before_save { self.email = email.downcase if email.present? }
  before_save { self.role ||= :member }

  validates :name, presence: true, length: { minimum: 1, maximum: 100 }

  validates :password, presence: true, length: { minimum: 6 }, unless: :password_digest
  validates :password, length: { minimum: 6 }, allow_blank: true

  validates :email, presence: true, length: { minimum: 3, maximum: 254 },
            uniqueness: { case_sensitive: false }

  has_secure_password

  #enum role: { member: 0, admin: 1 }
  enum role: [:member, :admin]


  def favorite_for(post)
    favorites.where(post_id: post.id).first
  end

  def avatar_url(size)
    gravatar_id = Digest::MD5::hexdigest(self.email).downcase
    "http://gravatar.com/avatar/#{gravatar_id}.png?s=#{size}"
  end

  def has_posts?
    self.posts.count > 0
  end

  def has_comments?
    self.comments.count > 0
  end

  def has_favorited?
    favorites.any?
    #self.favorites.count > 0
  end



end
