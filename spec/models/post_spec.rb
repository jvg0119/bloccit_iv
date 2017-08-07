require 'rails_helper'

RSpec.describe Post, type: :model do
  # let(:post) { Post.create!(title: "My Title", body: "my body") }
  # let(:name) { RandomData.random_sentence }
  # let(:description) { RandomData.random_paragraph }
  # let(:title) { RandomData.random_sentence }
  # let(:body) { RandomData.random_paragraph }

#  let(:user) {  User.create!(name: "Bloccit User", email: "user@bloccit.com", password: "helloworld")}
#  let(:topic) { Topic.create!(name: name, description: description) }
  # let(:post) { topic.posts.create!(title: title, body: body)}
  # adding user scope to post
#  let(:post) { topic.posts.create!(title: title, body: body, user: user )}

  let(:user) { create(:user) }
  let(:topic) { create(:topic) }
  let(:post) { create(:post) }


  it { is_expected.to have_many(:labelings) }
  it { is_expected.to have_many(:labels).through(:labelings) }


  # it { should belong_to(:topic) } # OK, same as below
  it { is_expected.to belong_to(:topic) }
  it { is_expected.to belong_to(:user) }
  it { is_expected.to have_many(:comments) } # adding this now on cp 41 comments

  it { is_expected.to have_many(:votes) }

  it { is_expected.to have_many(:favorites) }

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


  describe "attributes" do
    #it "has title and body" do
    it "has title, body and user attributes" do # adding user attribute
      expect(post).to have_attributes(title: post.title , body: post.body)

#      expect(post).to have_attributes(title: title, body: body, user: user)
    # post = Post.new(title: "My Title", body: "my body")
    # expect(post).to have_attributes(title: "My Title", body: "my body")
    end
  end

  describe "voting" do
    before do
      3.times { Vote.create!(value: 1, post: post, user: user) }
  #    3.times { post.votes.create!(value: 1) }
      2.times { Vote.create!(value: -1, post: post, user: user) }
      @up_votes = post.up_votes#.where(value: 1)#.count
      @down_votes = post.down_votes#.where(value: -1)#.count
    end

    describe "#up_votes" do
      it "counts the number of votes with the value = 1" do
        expect(post.up_votes).to eq(@up_votes)
        # Vote.create!(value: 1, post: post, user: user)
        # Vote.create!(value: 1, post: post, user: user)
        # p post.up_votes
        # p post.up_votes
      end
    end
    describe "#down_votes" do
      it "counts the number of votes with the value = -1" do
        expect(post.down_votes).to eq(@down_votes)
      end
    end
    describe "#points" do
      it "returns the sum of all down and up votes" do
      #  expect(post.points).to eq(1)
        expect(post.points).to eq(@up_votes - @down_votes)
      end
    end
  end

  describe "#update_rank" do
    it "calculates the correct rank" do
      post.update_rank
      expect(post.rank).to eq (post.points + (post.created_at - Time.new(1970,1,1)) / 1.day.seconds)
    end
    it "updates the rank when an up vote is created" do
      post.votes.create!(value: 1, user: user) # need to create vote to set the initial rank
      old_rank = post.rank
      post.votes.create!(value: 1, user: user)
      expect(post.rank).to eq (old_rank + 1)
    end
    it "updates the rank when a down vote is created" do
      post.votes.create!(value: 1, user: user) # added to give an initial rank
      old_rank = post.rank
      post.votes.create!(value: -1, user: user)
      expect(post.rank).to eq (old_rank - 1)
    end
  end

end
