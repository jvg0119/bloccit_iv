require 'rails_helper'

RSpec.describe Api::V1::PostsController, type: :controller do
  let(:my_topic) { create(:topic) }
  let(:my_post) { create(:post, topic: my_topic) }
  let(:my_user) { create(:user) }

  context "unauthenticated user" do
    it "GET index returns http success" do
      get :index
      expect(response).to have_http_status(:success)
    end
    it "GET show returns http success" do
      get :show, params: { id: my_post.id }
      expect(response).to have_http_status(:success)
    end
    it "PUT patch returns http unauthenticated" do  #
      put :update, params: { id: my_post.id }
      expect(response).to have_http_status(401)
    end
    it "POST create returns http unauthenticated" do
      post :create, params: { post: attributes_for(:post) }
      expect(response).to have_http_status(401)
    end
    it "DELETE destroy returns http unauthenticated" do
      delete :destroy, params: { id: my_post.id }
      expect(response).to have_http_status(401)
    end
  end   # unauthenticated user

  context "unauthorized user" do
    before do
      controller.request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Token.encode_credentials(my_user.auth_token)
    end
    it "GET index returns http success" do
      get :index
      expect(response).to have_http_status(:success)
    end
    it "GET show returns http success" do
      get :show, params: { id: my_post.id }
      expect(response).to have_http_status(:success)
    end
    it "PUT update returns http forbidden" do
      put :update, params: { id: my_post.id }
      expect(response).to have_http_status(403)
    end
    it "POST create returns http forbidden" do
      post :create, params: { post: attributes_for(:post) }
      expect(response).to have_http_status(403)
    end
    it "DELETE destroy returns http forbidden" do
      delete :destroy, params: { id: my_post.id }
      expect(response).to have_http_status(403)
    end
  end   # unauthorized user

  context "authenticated and authorized users" do
    before do
      my_user.admin! # authorized user
      controller.request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Token.encode_credentials(my_user.auth_token) # authenticated user
      #@new_post = build(:post)
    end
    it "GET index returns http success" do
      get :index
      expect(response).to have_http_status(:success)
    end
    it "GET show returns http success" do
      get :show, params: { id: my_post.id }
      expect(response).to have_http_status(:success)
    end
    describe "PUT update" do
      it "returns http success" do
        put :update, params: { topic_id: my_topic.id, id: my_post.id, post: attributes_for(:post) }
        expect(response).to have_http_status(:success)
      end
      it "returns json content type" do
        put :update, params: { topic_id: my_topic.id, id: my_post.id, post: attributes_for(:post) }
        expect(response.content_type).to eq("application/json")
      end
      it "updates post with the correct attributes (1)" do
        post_attributes = attributes_for(:post, title: "updated title")
        put :update, params: { topic_id: my_topic.id, id: my_post.id, post: post_attributes }

        json_parse = JSON.parse(response.body)
        topic = Topic.find(my_topic.id)
        updated_post = topic.posts.find(my_post.id)

        expect(json_parse['id']).to eq(my_post.id)
        expect(json_parse['title']).to eq(my_post.reload.title)
        expect(json_parse['body']).to eq(my_post.body)
      end
      # it "updates post with the correct attributes (2)" do
      #   new_post = build(:post)
      #   put :update, params: { topic_id: my_topic.id, id: my_post.id, post: {title: new_post.title, body: new_post.body} }
      #
      #   topic = Topic.find(my_topic.id)
      #   updated_post = topic.posts.find(my_post.id)
      #   expect(response.body).to eq(updated_post.to_json)  # does not work; it's different order
      # end
    end
    describe "POST create" do
      before do
        @new_post = build(:post)
        post :create, params: { topic_id: my_topic.id, post: {title: @new_post.title, body: @new_post.body} }
      end
      it "returns http success" do
        expect(response).to have_http_status(:success)
      end
      it "returns json content type" do
        expect(response.content_type).to eq("application/json")
      end
      it "creates the post with the correct attributes" do
        json_parse = JSON.parse(response.body)
        expect(json_parse['title']).to eq(@new_post.title)
        expect(json_parse['body']).to eq(@new_post.body)
        expect(json_parse['id']).to eq(Post.last.id)
      end
    end
    describe "DELETE destroy" do
      before { delete :destroy, params: { topic_id: my_topic.id, id: my_post.id} }
      it "returns http success" do
        expect(response).to have_http_status(:success)
      end
      it "returns json content type" do
        expect(response.content_type).to eq("application/json")
      end
      it "returns the correct json message" do
        expect(response.body).to eq({ message: "Post destroyed", status: 200 }.to_json)
      end
      it "deletes my_post" do
        expect{Post.find(my_post.id)}.to raise_exception(ActiveRecord::RecordNotFound)
      end
    end
  end   # authenticated and authorized users
end   # RSpec.describe Api::V1::PostsController
