require 'rails_helper'

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


end
