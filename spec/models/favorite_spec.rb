require 'rails_helper'

RSpec.describe Favorite, type: :model do
  # let(:topic) { Topic.create!(name: RandomData.random_sentence, description: RandomData.random_paragraph) }
  # let(:user) { User.create!(name: "Bloccit User", email: "user@bloccit.com", password: "password") }
  # let(:post) { topic.posts.create!(title: RandomData.random_sentence, body: RandomData.random_paragraph, user: user ) }

  let(:topic) { create(:topic) }
  let(:user) { create(:user) }
  let(:post) { create(:post) }
  #let(:favorite) { Favorite.create!(user: user, post: post) }
  let(:favorite) { create(:favorite) }

  it { is_expected.to belong_to(:user) }
  it { is_expected.to belong_to(:post) }

end
