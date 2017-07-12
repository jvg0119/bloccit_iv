require 'rails_helper'

RSpec.describe Question, type: :model do
  let(:question) { Question.create!(title: "My Question Title", body: "My question body", resolve: false) }

  describe "attributes" do
    it "has title and body attributes" do
        expect(question).to have_attributes(title: "My Question Title", body: "My question body", resolve: false)
    end
  end

  it "should respond to attribute title" do
    expect(question).to respond_to(:title)
  end
  it "should respond to attribute body" do
    expect(question).to respond_to(:body)
  end
  it "should respond to attribute resolve" do
    expect(question).to respond_to(:resolve)
  end
end
