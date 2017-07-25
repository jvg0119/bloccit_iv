require 'rails_helper'

RSpec.describe Post, type: :model do
  # let(:post) { Post.create!(title: "My Title", body: "my body") }
  let(:name) { RandomData.random_sentence }
  let(:description) { RandomData.random_paragraph }
  let(:title) { RandomData.random_sentence }
  let(:body) { RandomData.random_paragraph }

  let(:user) {  User.create!(name: "Bloccit User", email: "user@bloccit.com", password: "helloworld")}
  let(:topic) { Topic.create!(name: name, description: description) }
  # let(:post) { topic.posts.create!(title: title, body: body)}
  # adding user scope to post
  let(:post) { topic.posts.create!(title: title, body: body, user: user )}


  it { is_expected.to have_many(:labelings) }
  it { is_expected.to have_many(:labels).through(:labelings) }


  # it { should belong_to(:topic) } # OK, same as below
  it { is_expected.to belong_to(:topic) }
  it { is_expected.to belong_to(:user) }
  it { is_expected.to have_many(:comments) } # adding this now on cp 41 comments

  describe "attributes" do
    #it "has title and body" do
    it "has title, body and user attributes" do # adding user attribute
      expect(post).to have_attributes(title: title, body: body, user: user)
    # post = Post.new(title: "My Title", body: "my body")
    # expect(post).to have_attributes(title: "My Title", body: "my body")
    end
  end

# ==== validations =====
  it { is_expected.to validate_presence_of(:title) }
  it { is_expected.to validate_presence_of(:body) }
  it { is_expected.to validate_length_of(:title).is_at_least(5) }
  it { is_expected.to validate_length_of(:body).is_at_least(20) }

  it { is_expected.to validate_presence_of(:topic) }
  it { is_expected.to validate_presence_of(:user) }

  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:body) }
  it { should validate_length_of(:title).is_at_least(5) }
  it { should validate_length_of(:body).is_at_least(20) }

end
