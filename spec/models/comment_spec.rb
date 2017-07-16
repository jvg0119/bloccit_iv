require 'rails_helper'

RSpec.describe Comment, type: :model do
  # let(:post) { Post.create!(title: "My Post Title", body: "My post body") }
  # let(:comment) { post.comments.create!(body: "My comment body") }
  let(:topic) { Topic.create!(name: RandomData.random_sentence, description: RandomData.random_paragraph) }
  let(:post) { topic.posts.create!(title: RandomData.random_sentence, body: RandomData.random_paragraph) }
  let(:comment) { Comment.create!(body: "my comment body", post: post) }

  describe "attributes" do
    it "has a body attribute" do
      expect(comment).to have_attributes(body: "my comment body", post: post)
    end
  end

end
