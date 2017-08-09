require 'rails_helper'

RSpec.describe Api::V1::TopicsController, type: :controller do
  let(:my_user) { create(:user) }
  let(:my_topic) { create(:topic) }
  let(:my_post) { create(:post, topic: my_topic, user: my_user) }
  let(:my_post2) { create(:post, title: "anather title", topic: my_topic, user: my_user) }

  context "unauthenticated user" do
    describe "GET index" do
      it "returns an http success" do
        get :index
        expect(response).to have_http_status(:success)
      end
    end
    describe "GET show" do
      it "returns an http success" do
        get :show, params: { id: my_topic.id }
        expect(response).to have_http_status(:success)
      end
      it "returns child posts" do # bloc solution
        get :show, params: { id: my_topic.id }
        json_hash = JSON.parse(response.body)
        expect(json_hash['posts']).to_not be nil
      end
      it "returns child posts (2)" do # my solution 
        get :show, params: { id: my_topic.id, post_id: [my_post.id, my_post2.id] }
        json_hash = JSON.parse(response.body)
        expect(json_hash['posts'].first['title']).to eq(my_post.title)
        expect(json_hash['posts'].last['title']).to eq(my_post2.title)
      end
    end
  end   # unauthenticated user

  context "unauthorized user" do
    before do
      controller.request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Token.encode_credentials(my_user.auth_token)
      controller.authenticate_user
    end
    describe "GET show" do
      it "returns an http success" do
        get :show, params: { id: my_topic.id }
        expect(response).to have_http_status(:success)
      end
      it "returns child posts" do
        get :show, params: { id: my_topic.id }
        json_hash = JSON.parse(response.body)
        expect(json_hash['posts']).to_not be nil
      end
      it "returns child posts (2)" do
        get :show, params: { id: my_topic.id, post_id: [my_post.id, my_post2.id] }
        json_hash = JSON.parse(response.body)
        expect(json_hash['posts'].first['title']).to eq(my_post.title)
        expect(json_hash['posts'].last['title']).to eq(my_post2.title)
      end
    end
  end   # unauthorized user

end
