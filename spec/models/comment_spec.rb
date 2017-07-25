require 'rails_helper'

RSpec.describe Comment, type: :model do
  # let(:post) { Post.create!(title: "My Post Title", body: "My post body") }
  # let(:comment) { post.comments.create!(body: "My comment body") }

  let(:user) {  User.create!(name: "Bloccit User", email: "user@bloccit.com", password: "helloworld")}
  let(:topic) { Topic.create!(name: RandomData.random_sentence, description: RandomData.random_paragraph) }

  #let(:post) { topic.posts.create!(title: RandomData.random_sentence, body: RandomData.random_paragraph) }
  let(:post) { topic.posts.create!(title: RandomData.random_sentence, body: RandomData.random_paragraph, user: user) }
  # let(:comment) { Comment.create!(body: "my comment body", post: post) }
  #let(:comment) { Comment.create!( body: "my comment body", post: post, user: user ) }
  let(:comment) { Comment.create!( body: "my comment body", user: user ) }


  # add comment interface model (assign 42 Labels)
  it { is_expected.to have_many(:commentings) }

  # add comments to topics & posts (assign 42 Labels)
  it { is_expected.to have_many(:topics).through(:commentings) }
  it { is_expected.to have_many(:posts).through(:commentings) }


  # test belongs to user & post
#  it { is_expected.to belong_to(:post) } # removed for assign 42 Labels
  it { is_expected.to belong_to(:user) }

  # test comment validations
  it {  is_expected.to validate_presence_of(:body) }
  it { is_expected.to validate_length_of(:body).is_at_least(5) }

  describe "attributes" do
    it "has a body attribute" do
    #  expect(comment).to have_attributes(body: "my comment body", post: post, user: user)
      expect(comment).to have_attributes(body: "my comment body", user: user)
    end
  end

  # assign 42 Labels
  describe "commentings" do
    it "allows the same comment to be associated with a different topic or post" do
      topic.comments << comment
      post.comments << comment

      topic_comment = topic.comments[0]
      post_comment = post.comments[0]
      #
       expect(topic_comment).to eq(post_comment)
  #     byebug
    end
  end



end
