require 'rails_helper'

RSpec.describe Comment, type: :model do
  # let(:post) { Post.create!(title: "My Post Title", body: "My post body") }
  # let(:comment) { post.comments.create!(body: "My comment body") }

  let(:user) {  User.create!(name: "Bloccit User", email: "user@bloccit.com", password: "helloworld")}
  let(:topic) { Topic.create!(name: RandomData.random_sentence, description: RandomData.random_paragraph) }

  #let(:post) { topic.posts.create!(title: RandomData.random_sentence, body: RandomData.random_paragraph) }
  let(:post) { topic.posts.create!(title: RandomData.random_sentence, body: RandomData.random_paragraph, user: user) }
  # let(:comment) { Comment.create!(body: "my comment body", post: post) }
  let(:comment) { Comment.create!( body: "my comment body", post: post, user: user ) }


  # test belongs to user & post
  it { is_expected.to belong_to(:post) }
  it { is_expected.to belong_to(:user) }

  # test comment validations
  it {  is_expected.to validate_presence_of(:body) }
  it { is_expected.to validate_length_of(:body).is_at_least(5) }

  describe "attributes" do
    it "has a body attribute" do
      expect(comment).to have_attributes(body: "my comment body", post: post, user: user)
    end
  end

end
