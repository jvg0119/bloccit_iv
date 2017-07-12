require 'rails_helper'

RSpec.describe Answer, type: :model do
  let(:question) { Question.create!(title: "My Question Title", body: "My question body") }
  let(:answer) { Answer.create!(body: "My answer body", question: question) }

  describe "attributes" do
    it "has body attributes" do
      expect(answer).to have_attributes(body: "My answer body")
    end
  end
end
