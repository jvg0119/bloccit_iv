class Post < ApplicationRecord
  belongs_to :topic#, optional: true # posts needs topic bypass for now
  belongs_to :user#, optional: true
  has_many :comments, dependent: :destroy

  has_many :labelings, as: :labelable
  has_many :labels, through: :labelings

  has_many :votes, dependent: :destroy


  validates :topic, presence: true
  validates :title, presence: true, length: { minimum: 5 }
  validates :body, presence: true, length: { minimum: 20 }

  # added per bloc but rails 5 automatically sets these unless bypassed
  validates :topic, presence: true
  validates :user, presence: true

  #default_scope { order('created_at DESC') }
  default_scope { self.order('rank DESC') }

  after_create :create_vote

  def up_votes
    votes.where(value: 1).count
  end

  def down_votes
    votes.where(value: -1).count
  end

  def points
  #  up_votes - down_votes # works
    votes.sum(:value)
  end

  def update_rank
    age_in_days = (created_at - Time.new(1970,1,1)) / 1.day.seconds
    new_rank = points + age_in_days
    update_attribute(:rank, new_rank)
  end

#  private
  def create_vote
    #self.user.votes.create(value: 1, post: self)
    self.votes.create(value: 1, post: self, user: self.user)
  end

end
