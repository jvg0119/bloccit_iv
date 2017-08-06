class Topic < ApplicationRecord
  has_many :posts, dependent: :destroy

  # define a has_many relationship between Topic and Labeling, using the  labeleable interface
  has_many :labelings, as: :labelable

  # define a has_many relationship between Topic to Label,
  # using the  Labeling class through the labeleable interface.
  has_many :labels, through: :labelings

  scope :publicly_viewable, -> { self.where(public: true) }
  scope :privately_viewable, -> { self.where(public: false) }
  #scope :visible_to, -> (user) { user ? all : where(public: true ) }
  scope :visible_to, -> (user) { user ? all : publicly_viewable }

end
