require 'rails_helper'
include SessionsHelper

RSpec.describe VotesController, type: :controller do

#  let(:my_user) { User.create!(name: "Bloccit User", email: "user@bloccit.com", password: "password") }
#  let(:other_user) { User.create!(name: RandomData.random_name, email: RandomData.random_email, password: "password", role: :member) }
#  let(:my_topic) { Topic.create!(name: RandomData.random_sentence, description: RandomData.random_paragraph) }
  let(:user_post) { my_topic.posts.create!(title: RandomData.random_sentence, body: RandomData.random_paragraph, user: other_user) }

   let(:my_user) { create(:user) }
   let(:other_user) { create(:user) }
   let(:my_topic) { create(:topic) }
   let(:user_post) { create(:post, user: other_user, topic: my_topic) }


  #let(:my_vote) { Vote.create!(value: 1) }
  let(:my_vote) { create(:vote) }

  # adding this post to create my own test
  # let(:other_post) { my_topic.posts.create!(title: RandomData.random_sentence, body: RandomData.random_paragraph, user: my_user) }
  let(:other_post) { create(:post, topic: my_topic, user: my_user) }

  context "guest" do
    describe "POST up_vote" do
      it "redirects the user to the sign in view" do
        post :up_vote, params: { post_id: user_post.id }
        expect(response).to redirect_to(new_session_path)
      end
    end
    describe "POST down_vote" do
      it "redirects the user to the sign in view" do
        post :down_vote, params: { post_id: user_post.id }
        expect(response).to redirect_to(new_session_path)
      end
    end
  end   # guest

  context "signed user" do
    before do
      create_session(my_user)
      request.env['HTTP_REFERER'] = topic_post_path(my_topic, user_post)
    end
    describe "POST up_vote" do
      it "the users first vote increases the number of post votes by one" do
        votes = user_post.votes.count # number of votes for this post (user_post)
        post :up_vote, params: { post_id: user_post.id }
        expect(user_post.votes.count).to eq(votes + 1)  # adding 1 to the current numbber of votes for this post
      end
      it "the uses second vote does not increase the number of post votes" do
        post :up_vote, params: { post_id: user_post.id }
        votes = user_post.votes.count
        post :up_vote, params: { post_id: user_post.id }
        expect(user_post.votes.count).to eq(votes)
      end
      it "the uses second vote does not increase the number of post votes (same test as above)" do
        votes = user_post.votes.count
        post :up_vote, params: { post_id: other_post.id }
        expect(user_post.votes.count).to eq(votes)
      end
      it "increases the sum of post votes by one" do
        points = user_post.points
        post :up_vote, params: { post_id: user_post.id }
        expect(user_post.points).to eq(points + 1)
      end
      it ":back redirects to post show page" do
        request.env["HTTP_REFERER"] = topic_post_path(my_topic, user_post)
        post :up_vote, params: { post_id: other_post.id }
      #  expect(response).to redirect_to([my_topic, user_post])
      end
      it ":back redirects to post topic show page" do
        request.env["HTTP_REFERER"] = topic_path(my_topic)
        post :up_vote, params: { post_id: other_post.id }
      #  expect(response).to redirect_to(my_topic)
      end
    end

    describe "POST down_vote" do
      it "the users first vote increases the number of post votes by one" do
        votes = user_post.votes.count # number of votes for this post (user_post)
        post :down_vote, params: { post_id: user_post.id }
        expect(user_post.votes.count).to eq(votes + 1)  # adding 1 to the current numbber of votes for this post
      end
      it "the uses second vote does not increase the number of post votes" do
        post :down_vote, params: { post_id: user_post.id }
        votes = user_post.votes.count
        post :down_vote, params: { post_id: user_post.id }
        expect(user_post.votes.count).to eq(votes)
      end
      it "the uses second vote does not increase the number of post votes (same test as above)" do
        votes = user_post.votes.count
        post :down_vote, params: { post_id: other_post.id }
        expect(user_post.votes.count).to eq(votes)
      end
      it "increases the sum of post votes by one" do
        points = user_post.points
        post :down_vote, params: { post_id: user_post.id }
        expect(user_post.points).to eq(points - 1)
      end
      it ":back redirects to post show page" do
        request.env["HTTP_REFERER"] = topic_post_path(my_topic, user_post)
        post :down_vote, params: { post_id: other_post.id }
      #  expect(response).to redirect_to([my_topic, user_post])
      end
      it ":back redirects to post topic show page" do
        request.env["HTTP_REFERER"] = topic_path(my_topic)
        post :down_vote, params: { post_id: other_post.id }
      #  expect(response).to redirect_to(my_topic)
      end
    end

  end # signed user

end
