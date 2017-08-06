require 'rails_helper'
include SessionsHelper

RSpec.describe Topic, type: :model do
  # let(:name) { RandomData.random_sentence }
  # let(:public) { true }
  # let(:description) { RandomData.random_paragraph }
  # let(:topic) { Topic.create!(name: name, description: description) }

  let(:topic) { create(:topic) }


  it { is_expected.to have_many(:posts) }

  it { is_expected.to have_many(:labelings) }
  it { is_expected.to have_many(:labels).through(:labelings) }


  describe "attributes" do
    it "has name, description and public attributes" do
      expect(topic).to have_attributes(name: topic.name, description: topic.description)
      #expect(topic).to have_attributes(name: name, description: description)
    end
    it "should respond to the name attribute" do
      expect(topic).to respond_to(:name)
    end
    it "should respond to the description attribute" do
      expect(topic).to respond_to(:description)
    end
    it "is public by default" do
      expect(topic.public).to be(true)
    end
  end

  describe "scopes" do
    before do
      @public_topic = create(:topic)
      @private_topic = create(:topic, public: false)
      # @public_topic = Topic.create!(name: RandomData.random_sentence, description: RandomData.random_paragraph)
      # @private_topic = Topic.create!(name: RandomData.random_sentence, description: RandomData.random_paragraph, public: false)
    end

    describe "publicly_viewable" do
      it "returns a collection of public topics" do
        expect(Topic.publicly_viewable).to eq([@public_topic])
      end
    end
    describe "privately_viewable" do
      it "returns a collection of private topics" do
        expect(Topic.privately_viewable).to eq([@private_topic])
      end
    end
    describe "visible_to(user)" do
      it "returns all topics if user is present" do
      #  user = build(:user) # OK
        user = User.new
        expect(Topic.visible_to(user)).to eq([@public_topic, @private_topic]) # OK
        expect(Topic.visible_to(user)).to eq(Topic.all)
      end
      it "does not returns only public topics if user is not present or nil" do
        expect(Topic.visible_to(nil)).to eq([@public_topic])
      end
    end
  end   # scopes


end
