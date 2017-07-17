class Post < ApplicationRecord
  belongs_to :topic#, optional: true # posts needs topic bypass for now
  has_many :comments, dependent: :destroy

  validates :topic, presence: true
  validates :title, presence: true, length: { minimum: 5 }
  validates :body, presence: true, length: { minimum: 20 }

end
