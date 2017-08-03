require 'rails_helper'

RSpec.describe SessionsController, type: :controller do
#  let(:my_user) { User.create!(name: "Blochead", email: "blochead@bloc.io", password: "password") }
  let(:my_user) { create(:user) }

  describe "GET #new" do
    it "returns http success" do
      get :new
      expect(response).to have_http_status(:success)
    end
  end   # GET #new

  describe "POST sessions" do
    it "returns http success" do
      # post :create, params: { session: { email: my_user.email, password: my_user.password } }
      # it needs to not sign up (in other words fail) in order to get have_http_status success
      # because signing up will render status 302 not 200
       post :create, params: { session: { email: my_user.email } }
      expect(response).to have_http_status(:success) # this is going back to render :new because it's not authenticating yet
    end
    it "initializes a session" do
      post :create, params: { session: { email: my_user.email, password: my_user.password } }
      expect(session[:user_id]).to eq(my_user.id)
      # this is creating session or signing up
    end
    it "does not add a user to session due to missing password" do
      post :create, params: { session: { email: my_user.email, password: '' } }
      expect(session[:user_id]).to be_nil # or be nil is OK also
    end
    it "flashes #error with bad email address" do
      post :create, params: { session: { email: "bad email" } } # same as above w/o password
      expect(flash.now[:alert]).to be_present
      # p flash.now[:alert]
      # p my_user
      # puts "==="
      # p params: { session: { email: "bad email" } }
      # expect(session[:user_id]).to be_nil
    end
    it "renders #new with bad email address" do
      post :create, params: { session: { email: "bad email" } }
      expect(response).to render_template(:new)
    end
    it "redirects to the root view" do
      post :create, params: { session: { email: my_user.email, password: my_user.password } }
      expect(response).to redirect_to(root_path) # signing up will redirect_to to root_path
    end
  end   # POST sessions

  describe "DELETE session/id" do
    it "render the #welcome view" do
      delete :destroy, params: { id: my_user.id }
      expect(response).to redirect_to(root_path)
    end
    it "deletes the user's session" do
      delete :destroy, params: { id: my_user.id }
      expect(assigns(:session)).to be_nil
    end
    it "flashes #notice" do
      delete :destroy, params: { id: my_user.id }
      expect(flash[:notice]).to be_present
    end
  end   #DELETE session/id

end
