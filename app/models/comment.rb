class Comment < ApplicationRecord
#  belongs_to :post  # remove for the assignment 42 Labels
  belongs_to :user#, optional: true

  has_many :commentings
  has_many :topics, through: :commentings, source: :commentable, source_type: :Topic, dependent: :destroy
  has_many :posts, through: :commentings, source: :commentable, source_type: :Post

  validates :body, presence: true,
            length: { minimum: 5 }

end
