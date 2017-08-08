require 'rails_helper'

RSpec.describe Api::V1::TopicsController, type: :controller do
  let(:my_user) { create(:user) }
  let(:my_topic) { create(:topic) }

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
        get :show, params: { id: my_topic.id }
        expect(response).to have_http_status(:success)
      end
    end
  end   # unauthorized user

end
