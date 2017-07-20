class Post < ApplicationRecord
  belongs_to :topic#, optional: true # posts needs topic bypass for now
  belongs_to :user
  has_many :comments, dependent: :destroy

  validates :topic, presence: true
  validates :title, presence: true, length: { minimum: 5 }
  validates :body, presence: true, length: { minimum: 20 }

  # added per bloc but rails 5 automatically sets these unless bypassed
  validates :topic, presence: true
  validates :user, presence: true

  default_scope { order('created_at DESC')} # newest first or on top

  # default_scope is always used unless you use .unscoped  method
  # like so:   Post.unscoped.ordered_by_title
  scope :ordered_by_title, -> { order(title: :DESC) } # title ASC number, symbos, Caps, small first
  scope :ordered_by_reverse_created_at, -> { order('created_at ASC')  } # oldest first or on top

end
