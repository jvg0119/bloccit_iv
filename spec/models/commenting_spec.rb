require 'rails_helper'

RSpec.describe Commenting, type: :model do

  it { is_expected.to belong_to(:comment) } # bloc did not have this test
  it { is_expected.to belong_to(:commentable) }

end
