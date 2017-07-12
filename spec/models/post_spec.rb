require 'rails_helper'

RSpec.describe Post, type: :model do
  let(:post) { Post.create!(title: "My Title", body: "my body") }
  describe "attributes" do
    it "has title and body" do
    # post = Post.new(title: "My Title", body: "my body")
      expect(post).to have_attributes(title: "My Title", body: "my body")
    end
  end

end
