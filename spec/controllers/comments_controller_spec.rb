require 'rails_helper'
include SessionsHelper

RSpec.describe CommentsController, type: :controller do
  # let(:my_user) { User.create!(name: "Bloccit User", email: "user@bloccit.com", password: "password")}
  # let(:other_user) { User.create!(name: "Other User", email: "other@bloccit.com", password: "password", role: :member)}
  # let(:my_topic) { Topic.create!(name: RandomData.random_name, description: RandomData.random_paragraph) }
  # let(:my_post) { my_topic.posts.create!(title: RandomData.random_sentence, body: RandomData.random_paragraph, user: my_user) }

  let(:my_user) { create(:user) }
  let(:other_user) { create(:user) }
  let(:my_topic) { create(:topic) }
  let(:my_post) { create(:post, topic: my_topic, user: my_user) }

  let(:my_comment) { Comment.create!(body: RandomData.random_sentence, user: my_user, post: my_post) }
#  let(:my_comment) { my_post.comments.create!(body: RandomData.random_sentence, user: my_user) }  # OK also

# =====================================================
  context "guest" do # they cannot create comments
    describe "POST #create" do
      it "redirects user to sign in view" do
        # post :create, params: { post_id: my_post.id, comment: { body: RandomData.random_paragraph } }
    #    post :create, params: { format: :js, post_id: my_post.id, comment: { body: RandomData.random_paragraph } }
        post :create, params: { format: :js, post_id: my_post.id, comment: attributes_for(:comment) }

        expect(response).to redirect_to(new_session_path) # to sign in page
      end
    end

    describe "DELETE #destroy" do # they cannot delete comments
      it "redirects user to sign in view" do
        # delete :destroy, params: { post_id: my_post.id, id: my_comment.id }
        delete :destroy, params: { format: :js, post_id: my_post.id, id: my_comment.id }
        expect(response).to redirect_to(new_session_path) # to sign in page
      end
    end
  end   # guest

# =====================================================
  context "member doing CRUD on comments they don't own" do
    before do
      create_session(other_user)
    end
    describe "POST #create" do # they can make a comment on other's post
      it "increases the number of comments by 1" do
      #   expect{ post :create, params: { post_id: my_post.id, comment: { body: RandomData.random_paragraph } }
      # }.to change( Comment, :count).by(1)
      expect{ post :create, params: { format: :js,  post_id: my_post.id, comment: { body: RandomData.random_paragraph } }
      }.to change( Comment, :count).by(1)
      end
      # it "redirects to the post show view" do
      #   post :create, params: { post_id: my_post.id, comment: { body: RandomData.random_paragraph } }
      #
      # #  expect(response).to redirect_to(topic_post_path(my_post.topic, my_post))  # OK long version
      #   expect(response).to redirect_to [my_topic, my_post] # post show page  no commnet show page
      # end
      it "renders http success" do
        #post :create, params: { post_id: my_post.id, comment: { body: RandomData.random_paragraph } }
        post :create, params: { format: :js, post_id: my_post.id, comment: { body: RandomData.random_paragraph } }
        expect(response).to have_http_status(:success)
      end
    end
# ****************************
    describe "DELETE #destroy" do # they cannot delete other's comment
      it "redirects user to the post show view" do # this will pass w/ or w/o the   "before_action :authorize_user, only: [:destroy]""
        delete :destroy, params: { post_id: my_post.id, id: my_comment.id }
        expect(response).to redirect_to([my_topic, my_post]) # post show page;  there is no comment show page
      end
      it "flashes an alert: 'You do not have permission to delete a comment.'" do
        #delete :destroy, params: { post_id: my_post.id, id: my_comment.id }
        delete :destroy, params: { format: :js, post_id: my_post.id, id: my_comment.id }
        expect(flash[:alert]).to be_present
      end
    end
  end   # member doing CRUD on comments they don't own

# =====================================================
  context "member doing CRUD on comments they own" do
    before do
      create_session(my_user)
    end
    describe "POST #create" do # they make comments on their own post
      it "increases the number of post by 1" do
      #   expect{ post :create, params: { post_id: my_post.id, comment: { body: RandomData.random_paragraph } }
      # }.to change( Comment, :count ).by(1)
        expect{ post :create, params: { format: :js, post_id: my_post.id, comment: {body: RandomData.random_paragraph } }
        }.to change(Comment, :count).by(1)
      end
      # it "redirects user to the post show view" do
      #   post :create, params: { post_id: my_post.id, comment: { body: RandomData.random_paragraph } }
      #   expect(response).to redirect_to([my_topic, my_post])
      # end
      it "returns http success" do
        post :create, params: { format: :js, post_id: my_post.id, comment: { body: RandomData.random_paragraph } }
        expect(response).to have_http_status(:success)
      end
    end

# ****************************
    describe "DELETE #destroy" do # they can delete their own comments; this passes w/ or w/o the 'before_action :authorize_user, only: [:destroy]'
      it "deletes the comment" do
        # delete :destroy, params: { post_id: my_post.id, id: my_comment.id }
        delete :destroy, params: { format: :js, post_id: my_post.id, id: my_comment.id }
        expect(Comment.where({id: my_comment.id}).count).to eq(0)
      end

      # it "redirects user to the post show view" do
      #   # delete :destroy, params: { post_id: my_post.id, id: my_comment.id }
      #   expect(response).to redirect_to([my_topic, my_post])
      # end
      # destroy action will redirect to the post show view.
      # Instead we expect to receive an HTTP success message
      it "returns http success" do
        delete :destroy, params: { format: :js, post_id: my_post.id, id: my_comment.id }
        expect(response).to have_http_status(:success)
      end
    end
  end   # member doing CRUD on comments they own

# =====================================================
  context "admin doing CRUD on comments they don't own" do
      before do
        other_user.admin!
        create_session(other_user)
      end
      describe "POST #create" do
      it "increases the number of post by 1" do
        expect{ post :create, params: { format: :js, post_id: my_post.id, comment: { body: RandomData.random_paragraph } }
      }.to change(Comment, :count).by(1)
      end
      # it "redirects user to the post show view" do
      #   post :create, params: { post_id: my_post.id, comment: { body: RandomData.random_paragraph }}
      #   expect(response).to redirect_to [my_topic, my_post]
      # end
      it "returns http success" do
        post :create, params: { format: :js, post_id: my_post.id, comment: { body: RandomData.random_paragraph } }
        expect(response).to have_http_status(:success)
      end
    end

# ****************************
    describe "DELETE #destroy" do
      it "deletes the comment" do
        #delete :destroy, params: { post_id: my_post.id, id: my_comment.id }
        #count = Comment.where({id: my_comment.id}).count # OK

        delete :destroy, params: { format: :js, post_id: my_post.id, id: my_comment.id }
        count = Comment.where(id: my_comment.id).count
        expect(count).to be_zero
      end
      # it "redirects user to the post show view" do
      #   delete :destroy, params: { post_id: my_post.id, id: my_comment.id }
      #   expect(response).to redirect_to [my_topic, my_post]
      # end
      # replace the one above
      # it no longer redirect_to
      it "returns http success" do
        delete :destroy, params: { format: :js, post_id: my_post.id, id: my_comment.id }
        expect(response).to have_http_status(:success)
      end
    end
  end   # admin doing CRUD on comments they don't own

end   # CommentsController
