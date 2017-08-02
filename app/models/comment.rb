class Comment < ApplicationRecord
  #belongs_to :post
  belongs_to :user

  belongs_to :commentable, polymorphic: true

  validates :body, presence: true

  validates :body, presence: true,
            length: { minimum: 5 }

end
