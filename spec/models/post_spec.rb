require 'rails_helper'

RSpec.describe Post, type: :model do
  # let(:post) { Post.create!(title: "My Title", body: "my body") }
  let(:name) { RandomData.random_sentence }
  let(:description) { RandomData.random_paragraph }
  let(:title) { RandomData.random_sentence }
  let(:body) { RandomData.random_paragraph }

  let(:topic) { Topic.create!(name: name, description: description) }
  let(:post) { topic.posts.create!(title: title, body: body)}

  # it { should belong_to(:topic) } # OK, same as below
  it { is_expected.to belong_to(:topic) }

  it { is_expected.to have_many(:comments) } # not on the bloc instructions

  describe "attributes" do
    it "has title and body" do
      expect(post).to have_attributes(title: title, body: body)
    # post = Post.new(title: "My Title", body: "my body")
    # expect(post).to have_attributes(title: "My Title", body: "my body")
    end
  end



end
