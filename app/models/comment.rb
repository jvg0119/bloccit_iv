class Comment < ApplicationRecord
  belongs_to :post, optional: true
  belongs_to :topic, optional: true
  belongs_to :user

  validates :body, presence: true,
            length: { minimum: 5 }

end
