require 'rails_helper'

RSpec.describe Api::V1::CommentsController, type: :controller do
  let(:my_user) { create(:user) }
  let(:my_topic) { create(:topic) }
  let(:my_post) { create(:post, topic: my_topic, user: my_user) }
  let(:my_comment) { create(:comment, post: my_post, user: my_user) }

  context "unauthenticated user" do
    describe "GET index" do
      it "returns http success" do
        get :index
        expect(response).to have_http_status(:success)
      end
    end
    describe "GET show" do
      it "returns http success" do
        get :show, params: { id: my_comment.id }
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
      it "returns http success" do
        get :index
        expect(response).to have_http_status(:success)
      end
    end
    describe "GET show" do
      it "returns http success" do
        get :show, params: { id: my_comment.id }
        expect(response).to have_http_status(:success)
      end
    end
  end   # unauthenticated user

end
