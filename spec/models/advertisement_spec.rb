require 'rails_helper'

RSpec.describe Advertisement, type: :model do
  let(:my_advertisement) { Advertisement.create!(title:"Advertisement title", body: "advertisement body", price: 100) }
  describe "attributes" do
    it "has title, body and price" do
      expect(my_advertisement).to have_attributes(title:"Advertisement title", body: "advertisement body", price: 100)
    end
    it "should respond to title" do
      expect(my_advertisement).to respond_to(:title)
    end
    it "should respond to body" do
      expect(my_advertisement).to respond_to(:body)
    end
    it "should response to price" do
      expect(my_advertisement).to respond_to(:price)
    end
  end
end
