require 'rails_helper'

RSpec.describe Question, type: :model do
  let(:question) { Question.create!(title: "Question Title", body: "question body", resolved: false) }

  it "should respond to the title attribute" do
    expect(question).to respond_to(:title)
  end
  it "should respond to body attribute" do
    expect(question).to respond_to(:body)
  end
  it "should respond to resolved attribute" do
    expect(question).to respond_to(:resolved)
  end
  describe "attributes" do
    it "has title, body, and resolved" do
      expect(question).to have_attributes(title: "Question Title", body: "question body", resolved: false)
    end
  end

end
