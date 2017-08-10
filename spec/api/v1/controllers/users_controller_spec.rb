require 'rails_helper'

RSpec.describe Api::V1::UsersController, type: :controller do
  let(:my_user) { create(:user) }

  context "unauthenticated users" do
    it "GET index returns http unauthenticated" do
      get :index
      expect(response).to have_http_status(401) # 401 unauthorized
    end
    it "GET show returns http unauthenticated" do
      get :show, params: { id: my_user.id }
      expect(response).to have_http_status(401)
    end
    it "PUT update returns http unauthenticated" do
      new_user = build(:user)
      put :update, params: { id: my_user.id, user: { name: new_user.name, email: new_user.email, password: new_user.password } }
    #  put :update, params: { id: my_user.id, user: attributes_for(:user, name: new_user.name) } # check this later
      expect(response).to have_http_status(401)
    end
    it "POST create returns http unauthenticated" do
    #  new_user = build(:user)
    #  post :create, params: { user: { name: new_user.name, email: new_user.email, password: new_user.password } }
     post :create, params: { user: attributes_for(:user) } # same result as the 2 lines above
     expect(response).to have_http_status(401)
    end
  end   # unauthenticated users

  context "authenticated and unauthorized users" do
    before do
      controller.request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Token.encode_credentials(my_user.auth_token)
    end
    it "GET index returns http forbidden" do
      get :index
      expect(response).to have_http_status(403) # 403 forbidden
    end
    it "GET show returns http forbidden" do
      get :show, params: { id: my_user.id }
      expect(response).to have_http_status(403)
    end
    it "PUT update returns http forbidden" do
      put :update, params: { id: my_user.id, user: attributes_for(:user) }
      expect(response).to have_http_status(403)
    end
    it "POST create returns http forbidden" do
      post :create, params: { user: attributes_for(:user) }
      expect(response).to have_http_status(403)
    end
  end   # authenticated and unauthorized users

  context "authenticated and authorized users" do
    before do
      my_user.admin!
      controller.request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Token.encode_credentials(my_user.auth_token)
    end
    describe "GET index" do
      before { get :index }
      it "returns http success" do
        expect(response).to have_http_status(:success) # 200
      end
      it "returns json content type" do
        expect(response.content_type).to eq("application/json")
      end
      it "returns my_user serialized" do
        expect(response.body).to eq([my_user].to_json)   # returns a serialized hash of your object 
      end
    end

    describe "GET show" do
      before { get :show, params: { id: my_user.id } }
      it "returns http success" do
        expect(response).to have_http_status(:success)
      end
      it "returns json content type" do
        expect(response.content_type).to eq("application/json")
      end
      it "returns my_user serialized" do
        expect(response.body).to eq(my_user.to_json)
      end
    end

    describe "PUT update" do
      context "with valid attributes" do
        it "returns http success" do
          put :update, params: { id: my_user.id, user: attributes_for(:user) }
          expect(response).to have_http_status(:success)
        end
        it "returns json content type " do
          put :update, params: { id: my_user.id, user: attributes_for(:user) }
          expect(response.content_type).to eq("application/json")
        end
        it "updates a user with the correct attributes" do
          new_user = build(:user)
          put :update, params: { id: my_user.id, user: { name: new_user.name, email: new_user.email, password: new_user.password, role: "admin" } }
          # put :update, params: { id: my_user.id, user: attributes_for(:user, name: new_user.name, email: new_user.email, password: new_user.password, role: "admin" ) }

          hashed_json = JSON.parse(response.body)

          expect(hashed_json['name']).to eq(new_user.name)
          expect(hashed_json['email']).to eq(new_user.email)
          expect(hashed_json['role']).to eq("admin")
        end
      end
      context "with invalid attributes" do
        before do
          put :update, params: { id: my_user.id, user: { name: "", email: "bademail@", password: "short" } }
        end
        it "returns an http error" do
          expect(response).to have_http_status(400) # Bad Request (ex: wrong syntax ...)
        end
        it "returns the correct json error message" do
          expect(response.body).to eq({error: "User update failed", status: 400}.to_json)
        end
      end
    end   # PUT update

    describe "POST create" do
      context "with valid attributes" do
        before do
          @new_user = build(:user, role: "admin")
          post :create, params: { user: { name: @new_user.name, email: @new_user.email, password: @new_user.password, role:  @new_user.role } }
        end
        it "returns http success" do
          expect(response).to have_http_status(:success)
        end
        it "returns json content type " do
          expect(response.content_type).to eq("application/json")
        end
        it "creates a post with the correct attributes" do
          hashed_json = JSON.parse(response.body)
          expect(hashed_json['name']).to eq(@new_user.name)
          expect(hashed_json['email']).to eq(@new_user.email)
          expect(hashed_json['role']).to eq(@new_user.role)
        end
      end
      context "with invalid attributes" do
        before do
          # @new_user = build(:user, role: "admin")
          # post :create, params: { user: { name: "", email: @new_user.email, password: @new_user.password, role:  @new_user.role } }
          post :create, params: { user: { name: "", email: "email@sample.com", password: "password" } }
        end
        it "returns http error" do
          expect(response).to have_http_status(400)
        end
        it "returns the correct json error message" do
          expect(response.body).to eq({error: "User is invalid", status: 400}.to_json)
        end
      end
    end   # POST create

  end   # authenticated and authorized users

end
