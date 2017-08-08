require 'rails_helper'

RSpec.describe Api::V1::BaseController, type: :controller do
  let(:my_user) { create(:user) }

  context "authorized user" do

    describe "#authenticate_user" do
      before do
        controller.request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Token.encode_credentials(my_user.auth_token)
        controller.authenticate_user
      end
      it "finds a user by their authentication token" do
        expect(assigns(:current_user)).to eq(my_user)
        # assigns(:current_user) is @current_user = User.find_by(auth_token: token)
      end

    end   # authenticate_use

  end   # authorized user

end
