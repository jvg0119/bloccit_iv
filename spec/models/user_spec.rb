require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { User.create!(name: "Blocit Use", email: "user@bloccit.com", password: "password") }

# cp 39 posts-users  associate post & user models
  it { is_expected.to have_many(:posts) }
  it { is_expected.to have_many(:comments) } 

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
    it "responds to roles" do
      expect(user).to respond_to(:role)
    end
    it "responds to admin?" do
      expect(user).to respond_to("admin?")
      # p user
      # puts
      # p :admin?
    #  byebug
    end
    it "responds to member?" do
      expect(user).to respond_to(:member?)
    end
  end

  describe "roles" do
    it "is a memeber by default" do
      expect(user.role).to eq("member")
    end
    context "member user" do
      it "returns true for #member?" do
        expect(user.member?).to be_truthy
      end
      it "returns false for #admin?" do
        expect(user.admin?).to be_falsey
      end
    end
    context "admin user" do
      before do
        user.admin!
      end
      it "returns true for #admin?" do
        expect(user.admin?).to be_truthy
      end
      it "returns false for #member?" do
        expect(user.member?).to be_falsey
      end
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
