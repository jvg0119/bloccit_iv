class Post < ApplicationRecord
  belongs_to :topic#, optional: true # posts needs topic bypass for now
  has_many :comments, dependent: :destroy

end
