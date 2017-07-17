require 'rails_helper'

RSpec.describe SponsoredPost, type: :model do
  let(:topic) { Topic.create!(name: "Topic Name", description: "this is the topic body")}
  let(:sponsored_post) { topic.sponsored_posts.create!(title: "SponsoredPost Title", body: "this is the sponsored post body", price: 25) }

  it { should belong_to(:topic) }

  describe "attributes" do
    it "has title, body, and price attributes" do
      expect(sponsored_post).to have_attributes(title: "SponsoredPost Title", body: "this is the sponsored post body", price: 25)
    end
    it "responds to title attributes" do
      expect(sponsored_post).to respond_to(:title)
    end
    it "responds to body attributes" do
      expect(sponsored_post).to respond_to(:body)
    end
    it "responds to price attributes" do
      expect(sponsored_post).to respond_to(:price)
    end
  end
end
