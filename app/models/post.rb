class Post < ApplicationRecord
  belongs_to :topic#, optional: true # posts needs topic bypass for now
  belongs_to :user
  #has_many :comments, dependent: :destroy # remove for the assignment 42 Labels
  # ActiveRecord::HasManyThroughOrderError:
  # Cannot have a has_many :through association 'Post#comments'
  # which goes through 'Post#commentings' before the through association is defined.

  has_many :labelings, as: :labelable
  has_many :labels, through: :labelings

  has_many :commentings, as: :commentable
  has_many :comments, through: :commentings

  validates :topic, presence: true
  validates :title, presence: true, length: { minimum: 5 }
  validates :body, presence: true, length: { minimum: 20 }

  # added per bloc but rails 5 automatically sets these unless bypassed
  validates :topic, presence: true
  validates :user, presence: true

  default_scope { order('created_at DESC')}

end
