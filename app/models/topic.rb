class Topic < ApplicationRecord
  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy

  # define a has_many relationship between Topic and Labeling, using the  labeleable interface
  has_many :labelings, as: :labelable

  # define a has_many relationship between Topic to Label,
  # using the  Labeling class through the labeleable interface.
  has_many :labels, through: :labelings


end



# it { is_expected.to have_many(:labelings) }
# it { is_expected.to have_many(:labels).through(:labelings) }
