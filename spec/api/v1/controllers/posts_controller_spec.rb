require 'rails_helper'

RSpec.describe Api::V1::PostsController, type: :controller do
  let(:my_user) { create(:user)}
  let(:my_topic) { create(:topic) }
  let(:my_post) { create(:post, topic: my_topic, user: my_user) }
  let(:my_comment) { create(:comment, post: my_post, user: my_user) }

  context "unauthenticated user" do
    describe "GET index" do
      it "returns an http success" do
        get :index
        expect(response).to have_http_status(:success)
      end
    end
    describe "GET show" do
      it "returns an http success" do
        get :show, params: { id: my_post.id }
        expect(response).to have_http_status(:success)
      end
      it "returns child comments" do
        get :show, params: { id: my_post.id }
        json_hash = JSON.parse(response.body)
        expect(json_hash['comments']).to_not be nil
      end
    end
  end   # unauthenticated user

  context "unauthorized user" do
    before do
      controller.request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Token.encode_credentials(my_user.auth_token)
      controller.authenticate_user
    end
    describe "GET index" do
      it "returns an http success" do
        get :index
        expect(response).to have_http_status(:success)
      end
    end
    describe "GET show" do
      it "returns an http success" do
        get :show, params: { id: my_post.id }
        expect(response).to have_http_status(:success)
      end
      it "returns child comments" do
        get :show, params: { id: my_post.id }
        json_hash = JSON.parse(response.body)
        expect(json_hash['comments']).to_not be nil
      end
      it "returns child comments (2)" do
        get :show, params: { id: my_post.id, comment_id: my_comment.id }
        json_hash = JSON.parse(response.body)
        expect(json_hash['comments'].first['body']).to eq(my_comment.body)
        expect(json_hash['comments'].first.to_json).to eq(my_comment.to_json) # pass; just exploring
      end
    end
  end   # unauthorized user

end   # Api::V1::PostsController
