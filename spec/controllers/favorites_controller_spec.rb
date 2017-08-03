require 'rails_helper'
include SessionsHelper

RSpec.describe FavoritesController, type: :controller do
  # let(:my_user) { User.create!(name: "Bloccit User", email: "user@bloccit.come", password: "password") }
  # let(:my_topic) { Topic.create!(name: RandomData.random_sentence, description: RandomData.random_paragraph)}
  # let(:my_post) { my_topic.posts.create!(title: RandomData.random_sentence, body: RandomData.random_paragraph, user: my_user) }

  let(:my_user) { create(:user) }
  let(:my_topic) { create(:topic) }
  let(:my_post) { create(:post, topic: my_topic, user: my_user) }

  context "guest" do
    describe "POST #create" do
      it "redirects user to sign in view (page)" do
        post :create, params: { post_id: my_post.id, favorite: { user: my_user } }
        expect(response).to redirect_to(new_session_path)
      end
    end
    describe "DELETE #destroy" do
      it "redirects user to sign in view (page)" do
      #  my_favorite = my_post.favorites.create(user: my_user) # same as below
        my_favorite = my_user.favorites.where(post: my_post).create
        delete :destroy, params: { post_id: my_post.id, id: my_favorite.id }
        expect(response).to redirect_to(new_session_path)
      end
    end
  end   # guest

  context "signed user" do
    before do
      create_session(my_user)
    end
    describe "POST #create" do
      it "creates a favorite for the current user and specified post" do
        expect(my_post.favorites.last).to be nil
        post :create, params: { post_id: my_post.id, favorite: { user: my_user } }
        expect(my_user.favorites.find_by_post_id(my_post.id)).not_to be_nil

        # below will only work if you're using @favorite in the controller
        # @favorite allows access to assigns(:favorite)
        # expect(my_user.favorites.find_by_post_id(my_post.id)).to eq(my_post.favorites.last)
        # expect(assigns(:favorite)).to eq(my_post.favorites.last)
      end
      it "redirects to post show view (page)" do
        post :create, params: { post_id: my_post.id, favorite: { user: my_user } }
        expect(response).to redirect_to([my_post.topic, my_post])
      end
    end
    describe "DELETE #destroy" do
      it "destroys the favorite for the current user and post" do
        # post :create, params: { post_id: my_post.id, favorite: { user: my_user } }
        # delete :destroy, params: { post_id: my_post.id, id: my_post.favorites.last.id }

        # creating my_favorite is a better way
        my_favorite = my_user.favorites.where(post: my_post).create
        expect(my_user.favorites.find_by_post_id(my_post.id)).to_not be nil

        delete :destroy, params: { post_id: my_post.id, id: my_favorite.id }
        expect(my_user.favorites.find_by_post_id(my_post.id)).to be nil
      end
      it "redirects to post show view (page)" do
        my_favorite = my_user.favorites.where(post: my_post).create
        delete :destroy, params: { post_id: my_post.id, id: my_favorite.id }

        expect(response).to redirect_to([my_post.topic, my_post])
      end
    end
  end   # signed user
end
