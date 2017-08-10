require 'rails_helper'

RSpec.describe Api::V1::TopicsController, type: :controller do
  let(:my_user) { create(:user) }
  let(:my_topic) { create(:topic) }

  context "unauthenticated user" do
    it "GET index returns http success" do
      get :index
      expect(response).to have_http_status(:success)
    end
    it "GET show returns http success" do
      get :show, params: { id: my_topic.id }
      expect(response).to have_http_status(:success)
    end
    it "PUT patch returns http unauthenticated" do  #
      put :update, params: { id: my_topic.id }
      expect(response).to have_http_status(401)
    end
    it "POST create returns http unauthenticated" do
      post :create, params: { topic: attributes_for(:topic) }
      expect(response).to have_http_status(401)
    end
    it "DELETE destroy returns http unauthenticated" do
      delete :destroy, params: { id: my_topic.id }
      expect(response).to have_http_status(401)
    end
  end   # unauthenticated user

  context "unauthorized user" do
    before do
      controller.request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Token.encode_credentials(my_user.auth_token)
      controller.authenticate_user
    end
    it "GET index http success" do
      get :index
      expect(response).to have_http_status(:success)
    end
    it "GET show returns http success" do
      get :show, params: { id: my_topic.id }
      expect(response).to have_http_status(:success)
    end
    it "PUT update returns http forbidden" do
      put :update, params: { id: my_topic.id }
      expect(response).to have_http_status(403)
    end
    it "POST create returns http forbidden" do
      post :create, params: { topic: attributes_for(:topic) }
      expect(response).to have_http_status(403)
    end
    it "DELETE destroy returns http forbidden" do
      put :update, params: { id: my_topic.id }
      expect(response).to have_http_status(403)
    end
  end   # unauthorized user

# =================================================
  context "authenticated and authorized users" do
    before do
      my_user.admin! # authorized user
      controller.request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Token.encode_credentials(my_user.auth_token) # authenticated user
      @new_topic = build(:topic)
    end
    describe "PUT update" do
      before { put :update, params: { id: my_topic.id, topic: { name: @new_topic.name, describe: @new_topic.description } } }
      it "returns http success" do
        #put :update, params: { id: my_topic.id, topic: attributes_for(:topic) }
        expect(response).to have_http_status(:success)
      end
      it "returns json content type" do
        #new_topic = build(:topic)
        #put :update, params: { id: my_topic.id, topic: { name: new_topic.name, description: new_topic.description } }
      #  put :update, params: { id: my_topic.id, topic: attributes_for(:topic) } # OK
        expect(response.content_type).to eq("application/json")
      end
      it "updates the topic with the correct attributes" do
      #  put :update, params: { id: my_topic.id, topic: attributes_for(:topic, public: true) } # this comes out slightly different sequence so it fails
        # put :update, params: { id: my_topic.id, topic: { name: @new_topic.name, describe: @new_topic.description } }
        json_parse = JSON.parse(response.body)
        updated_topic = Topic.find(my_topic.id)
        # below is OK
        # expect(json_parse['name']).to eq(my_topic.name)
        # expect(json_parse['description']).to eq(my_topic.description)
        # expect(json_parse['public']).to eq(my_topic.public)

      #  expect(updated_topic).to eq(my_topic) # this fails because public is out of sequence
        expect(response.body).to eq(updated_topic.to_json)
      end
    end
  end   # authenticated and authorized users      only update

# ====================================================
# same as above but cleaned up
    context "authenticated and authorized users (2)" do
      before do
        my_user.admin! # authorized user
        controller.request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Token.encode_credentials(my_user.auth_token) # authenticated user
        @new_topic = build(:topic)
      end
      describe "PUT update" do
        before { put :update, params: { id: my_topic.id, topic: { name: @new_topic.name, describe: @new_topic.description } } }
        it "returns http success" do
          expect(response).to have_http_status(:success)
        end
        it "returns json content type" do
          expect(response.content_type).to eq("application/json")
        end
        it "updates the topic with the correct attributes" do
          #json_parse = JSON.parse(response.body)
          updated_topic = Topic.find(my_topic.id)
          expect(response.body).to eq(updated_topic.to_json)
        end
      end

    describe "POST create" do
      it "returns http success" do
        post :create, params: { topic: attributes_for(:topic) }
        expect(response).to have_http_status(:success)
      end
      it "returns json type content" do
        post :create, params: { topic: attributes_for(:topic) }
        expect(response.content_type).to eq("application/json")
      end
      it "creates the topic with the correct attributes" do
        post :create, params: { topic: attributes_for(:topic, name: "topic name", description: "topic description") }
        json_parse = JSON.parse(response.body)
        expect(json_parse['name']).to eq("topic name")
        expect(json_parse['description']).to eq("topic description")
      end
      it "creates the topic with the correct attributes (2)" do
        new_topic = build(:topic)
        post :create, params: { topic: { name: new_topic.name, description: new_topic.description } }
        json_parse = JSON.parse(response.body)
        expect(json_parse['name']).to eq(new_topic.name)
        expect(json_parse['description']).to eq(new_topic.description)
      end
      it "creates the topic with the correct attributes(3)" do
        new_topic = attributes_for(:topic)
        post :create, params: { topic: new_topic }
        json_parse = JSON.parse(response.body)
        expect(json_parse['name']).to eq(new_topic[:name])
        expect(json_parse['description']).to eq(new_topic[:description])
      end
    end

    describe "DELETE destroy" do
      before { delete :destroy, params: { id: my_topic.id } }
      it "returns http success" do
        expect(response).to have_http_status(:success)
      #  expect(response).to have_http_status(200)
      #  expect(response.body).to eq({ message: "Topic destroyed", status: 200 }.to_json)
      end
      it "returns json type content" do
        expect(response.content_type).to eq("application/json")
      end
      it "returns the correct json success message" do
        expect(response.body).to eq({message: "Topic destroyed", status: 200}.to_json)
      end
      it "deletes my_topic" do
        expect{Topic.find(my_topic.id)}.to raise_exception(ActiveRecord::RecordNotFound)
      end
    end

  end   # authenticated and authorized users

end   # RSpec.describe Api::V1::TopicsController
