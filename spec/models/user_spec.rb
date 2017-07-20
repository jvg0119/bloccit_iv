require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { User.create!(name: "Blocit Use", email: "user@bloccit.com", password: "password") }

  it { is_expected.to have_many(:posts) }
  # cp 39 posts-users  associate post & user models

  # shoulda tests for name
  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_length_of(:name).is_at_least(1)}

  # should tests for email
  it { is_expected.to validate_presence_of(:email) }
  it { is_expected.to validate_uniqueness_of(:email) }
  it { is_expected.to validate_length_of(:email).is_at_least(3) }
  it { is_expected.to allow_value("user@bloccit.com").for(:email) }

  # shoulda tests for password
  it { is_expected.to validate_presence_of(:password) }
  it { is_expected.to have_secure_password }
  it { is_expected.to validate_length_of(:password).is_at_least(6) }

  describe "attributes" do
    it "should have a name and email" do
      expect(user).to have_attributes(name: "Blocit Use", email: "user@bloccit.com")
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

end
