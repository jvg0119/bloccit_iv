require 'rails_helper'

RSpec.describe Topic, type: :model do
  let(:name) { RandomData.random_sentence }
  let(:public) { true }
  let(:description) { RandomData.random_paragraph }
  let(:topic) { Topic.create!name: name, description: description }

  describe "attributes" do
    it "has name, description and public attributes" do
      expect(topic).to have_attributes(name: name, description: description)
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

  it { is_expected.to have_many(:posts) }

# ==== assignment cp 35 validations =====
  it { should have_many(:posts) }  # same as above

  it { is_expected.to validate_length_of(:name).is_at_least(5) }
  it { is_expected.to validate_length_of(:description).is_at_least(15) }

  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_presence_of(:description) }


end
