require 'rails_helper'

RSpec.describe Comment, type: :model do
  let(:post) { Post.create!(title: "My Post Title", body: "My post body") }
  let(:comment) { post.comments.create!(body: "My comment body") }
  describe "attributes" do
    it "has a body attribute" do
      expect(comment).to have_attributes(body: "My comment body")
    end
  end
end
