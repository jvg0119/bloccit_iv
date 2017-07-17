class Topic < ApplicationRecord
  has_many :posts, dependent: :destroy

  validates :name, presence: true, length: { minimum: 5 }
  validates :description, presence: true, length: { minimum: 15 }

end
