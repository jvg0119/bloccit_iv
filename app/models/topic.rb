class Topic < ApplicationRecord
  has_many :posts, dependent: :destroy

  # define a has_many relationship between Topic and Labeling, using the  labeleable interface
  has_many :labelings, as: :labelable

  # define a has_many relationship between Topic to Label,
  # using the  Labeling class through the labeleable interface.
  has_many :labels, through: :labelings

  scope :visible_to, -> (user) { user ? all : where(public: true ) }

end



# it { is_expected.to have_many(:labelings) }
# it { is_expected.to have_many(:labels).through(:labelings) }
