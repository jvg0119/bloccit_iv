require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { User.create!(name: "Blocit Use", email: "user@bloccit.com", password: "password") }

  # shoulda tests for name
  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_length_of(:name).is_at_least(1)}

  # should tests for email
  it { is_expected.to validate_presence_of(:email) }
  it { is_expected.to validate_uniqueness_of(:email) }
  it { is_expected.to validate_length_of(:email).is_at_least(3) }
  it { is_expected.to allow_value("user@bloccit.com").for(:email) }
#  it { is_expected.to validates_format_of(:email) }

  # shoulda tests for password
  it { is_expected.to validate_presence_of(:password) }
  it { is_expected.to have_secure_password }
  it { is_expected.to validate_length_of(:password).is_at_least(6) }

  describe "attributes" do
    it "should have a name and email" do
      expect(user).to have_attributes(name: "Blocit Use", email: "user@bloccit.com")
    end
    it "should format user's name" do
      user.name = "joe garcia"
      user.save
      expect(user.name).to eq("Joe Garcia")
    end
  end

  describe "invalid user" do
    let(:user_with_invalid_name) { User.new(name: '', email: "user@bloccit.com") }
    let(:user_with_invalid_email) { User.new(name: 'Bloccit User', email: "" )}

    it "should be invalid due to a blank name" do
      expect(user_with_invalid_name).to be_invalid
      expect(user_with_invalid_name).to_not be_valid
    end

    it "should be invalid due to a blank email" do
      expect(user_with_invalid_email).to be_invalid
      expect(user_with_invalid_email).to_not be_valid
    end
  end

# same test as the attributes should format user's name 
  describe "format_name method" do
    let(:user_name_not_formated) { User.create(name: 'joe garcia', email: "joe@bloccit.com", password: "password") }
    let(:user_name_formated) { User.create(name: 'Mike More', email: "mike@bloccit.com", password: "password") }

    it "capitalizes the first and last name of a full name" do
      expect(user_name_not_formated.name).to eq("Joe Garcia")
      expect(user_name_formated.name).to eq("Mike More")
    end
  end

end
