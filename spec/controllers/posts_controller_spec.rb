require 'rails_helper'

include SessionsHelper

RSpec.describe PostsController, type: :controller do
  # let(:my_user) { User.create!(name: "Bloccit User", email: "user@bloccit.io", password: "password") }
  # let(:other_user) { User.create!(name: RandomData.random_name, email: RandomData.random_email, password: "password", role: :member) }
  # let(:my_topic) { Topic.create!(name: RandomData.random_sentence, description: RandomData.random_paragraph) }
  # let(:my_post) { my_topic.posts.create!(title: RandomData.random_sentence, body: RandomData.random_paragraph, user: my_user) }

  let(:my_user) { create(:user) }
  let(:other_user) { create(:user) }
  let(:my_topic) { create(:topic) }
  let(:my_post) { create(:post, topic: my_topic, user: my_user) }

# =========================
# guest will be able to view posts
  context "guest" do
    describe "GET #show" do
      it "returns http success" do
        get :show, params: {topic_id: my_topic.id, id: my_post.id}
        expect(response).to have_http_status(:success)
      end
      it "assigns my_post to @post" do
        get :show, params: {topic_id: my_topic.id, id: my_post.id}
        expect(assigns(:post)).to eq(my_post)
      end
      it "renders the #show view" do
        get :show, params: {topic_id: my_topic.id, id: my_post.id}
        expect(response).to render_template(:show)
      end
    end   # GET #show

    describe "GET #new" do
      it "returns http redirect" do
        get :new, params: { topic_id: my_topic.id }
        expect(response).to redirect_to(new_session_path) # sign in page
      end
    end   # GET #new

    describe "POST #create" do
      it "returns http redirect" do
        post :create, params: { topic_id: my_topic.id, post: {title: RandomData.random_sentence, body: RandomData.random_paragraph} }
        expect(response).to redirect_to(new_session_path)
      end
    end   # POST #create

    describe "GET #edit" do
      it "returns http redirect" do
        get :edit, params: { topic_id: my_topic.id, id: my_post.id }
        expect(response).to redirect_to(new_session_path)
      end
    end   # GET #edit

    describe "PUT #update" do
      it "returns http redirect" do
        new_title = RandomData.random_sentence
        new_body = RandomData.random_paragraph
        put :update, params: { topic_id: my_topic.id, id: my_post.id, post: { title: new_title, body: new_body } }
        updated_post = assigns(:post)

        expect(response).to redirect_to(new_session_path)
      end
    end   # PUT #update

    describe "DELETE #destroy" do
      it "returns http redirect" do
        delete :destroy, params: { topic_id: my_topic.id, id: my_post.id }
        expect(response).to redirect_to(new_session_path)
      end
    end   # DELETE #destroy
  end   # guest

# =========================
# member cannot modify another user's post
  context "member user modifiying (doing CRUD) another user's post" do
    before do
      create_session(other_user)
    end

    describe "GET #show" do
      it "returns http success" do
        get :show, params: {topic_id: my_topic.id, id: my_post.id}
        expect(response).to have_http_status(:success)
      end
      it "assigns my_post to @post" do
        get :show, params: {topic_id: my_topic.id, id: my_post.id}
        expect(assigns(:post)).to eq(my_post)
      end
      it "renders the #show view" do
        get :show, params: {topic_id: my_topic.id, id: my_post.id}
        expect(response).to render_template(:show)
      end
    end   # GET #show

    describe "GET #new" do
      it "returns http success" do
        get :new, params: { topic_id: my_topic.id }
        expect(response).to have_http_status(:success)
      end
      it "instantiates @post" do
        get :new, params: { topic_id: my_topic.id }
        expect(assigns(:post)).not_to be_nil
      end
      it "renders the #new view" do
        get :new, params: { topic_id: my_topic.id }
        expect(response).to render_template(:new)
      end
    end   # GET #new

    describe "POST #create" do
      it "increases the number of Post by 1" do
        expect { post :create, params: { topic_id: my_topic.id, post: {title: RandomData.random_sentence, body: RandomData.random_paragraph} }
      }.to change{Post.count}.by(1)
      end
      it "assigns the new post to @post" do
        post :create, params: { topic_id: my_topic.id, post: {title: RandomData.random_sentence, body: RandomData.random_paragraph} }
        expect(assigns(:post)).to eq(Post.last)
      end
      it "redirects to the newly created post" do
        post :create, params: { topic_id: my_topic.id, post: {title: RandomData.random_sentence, body: RandomData.random_paragraph} }
        #expect(response).to redirect_to(post_path(Post.last))
        expect(response).to redirect_to([my_topic, Post.last]) # to post show page
      end
    end   # POST #create

    describe "GET #edit" do
      it "returns http redirect" do
        get :edit, params: { topic_id: my_topic.id, id: my_post.id }
        # expect(response).to redirect_to(topics_path)
        expect(response).to redirect_to([my_topic, my_post]) # to post show page; back to the same post
      end
    end   # GET #edit

    describe "PUT #update" do
      it "returns http redirect" do
        new_title = RandomData.random_sentence
        new_body = RandomData.random_paragraph
        put :update, params: { topic_id: my_topic.id, id: my_post.id, post: { title: new_title, body: new_body } }
        # this test will pass w/ or w/o the restriction because it gets redirected to the same place either way

        expect(response).to redirect_to([my_topic, my_post]) # this is post show page
      end
    end   # PUT #update

    describe "DELETE #destroy" do
      it "returns http redirect" do
        delete :destroy, params: { topic_id: my_topic.id, id: my_post.id }
        expect(response).to redirect_to([my_topic, my_post])
      end
    end   # DELETE #destroy
  end   # member modifiying another user's post

# =========================
# member can modify their own post
  context "member modifiying (doing CRUD) their own post" do
    before do
      create_session(my_user)
    end

    describe "GET #show" do
      it "returns http success" do
        get :show, params: {topic_id: my_topic.id, id: my_post.id}
        expect(response).to have_http_status(:success)
      end
      it "assigns my_post to @post" do
        get :show, params: {topic_id: my_topic.id, id: my_post.id}
        expect(assigns(:post)).to eq(my_post)
      end
      it "renders the #show view" do
        get :show, params: {topic_id: my_topic.id, id: my_post.id}
        expect(response).to render_template(:show)
      end
    end   # GET #show

    describe "GET #new" do
      it "returns http success" do
        get :new, params: { topic_id: my_topic.id }
        expect(response).to have_http_status(:success)
      end
      it "instantiates @post" do
        get :new, params: { topic_id: my_topic.id }
        expect(assigns(:post)).not_to be_nil
      end
      it "renders the #new view" do
        get :new, params: { topic_id: my_topic.id }
        expect(response).to render_template(:new)
      end
    end   # GET #new

    describe "POST #create" do
      it "increases the number of Post by 1" do
        expect { post :create, params: { topic_id: my_topic.id, post: {title: RandomData.random_sentence, body: RandomData.random_paragraph} }
      }.to change{Post.count}.by(1)
      end
      it "assigns the new post to @post" do
        post :create, params: { topic_id: my_topic.id, post: {title: RandomData.random_sentence, body: RandomData.random_paragraph} }
        expect(assigns(:post)).to eq(Post.last)
      end
      it "redirects to the newly created post" do
        post :create, params: { topic_id: my_topic.id, post: {title: RandomData.random_sentence, body: RandomData.random_paragraph} }
        #expect(response).to redirect_to(post_path(Post.last))
        expect(response).to redirect_to([my_topic, Post.last]) # to post show page
      end
    end   # POST #create

    describe "GET #edit" do
      it "returns http success" do
        get :edit, params: { topic_id: my_topic.id, id: my_post.id }
        expect(response).to have_http_status(:success)
      end
      it "assigns the post to be updated to @post" do
        get :edit, params: { topic_id: my_topic.id, id: my_post.id }
        post_instance = assigns(:post)

        expect(post_instance.id).to eq(my_post.id)
        expect(post_instance.title).to eq(my_post.title)
        expect(post_instance.body).to eq(my_post.body)
      end
      it "renders the edit template" do
        get :edit, params: { topic_id: my_topic.id, id: my_post.id }
        expect(response).to render_template(:edit)
      end
    end

    describe "PUT #update" do
      it "updates post with expected attributes" do
        new_title = RandomData.random_sentence
        new_body = RandomData.random_paragraph

        put :update, params: { topic_id: my_topic.id, id: my_post.id, post: { title: new_title, body: new_body } }
        updated_post = assigns(:post)

        expect(updated_post.id).to eq(my_post.id)
        expect(updated_post.title).to eq(new_title)
        expect(updated_post.body).to eq(new_body)
      end
      it "redirects to the updated post" do
        new_title = RandomData.random_sentence
        new_body = RandomData.random_paragraph

        put :update, params: { topic_id: my_topic.id, id: my_post.id, post: { title: new_title, body: new_body } }

        expect(response).to redirect_to([my_topic, my_post])
      end
    end   # PUT #update

    describe "DELETE #destroy" do
      it "deletes the post" do
        delete :destroy, params: { topic_id: my_topic.id, id: my_post.id }
        count = Post.where(id: my_post.id).size
        expect(count).to eq(0)
      end
      it "redirects to posts index view" do
        delete :destroy, params: { topic_id: my_topic.id, id: my_post.id }

        expect(response).to redirect_to(my_topic)
      end
    end   # DELETE #destroy
  end   # member modifiying (doing CRUD) their own post

# =========================
# admins will be able to create, update, or delete any post
  context "admin" do
    before do
      other_user.admin!
      create_session(other_user)
    end

    describe "GET #show" do
      it "returns http success" do
        get :show, params: {topic_id: my_topic.id, id: my_post.id}
        expect(response).to have_http_status(:success)
      end
      it "assigns my_post to @post" do
        get :show, params: {topic_id: my_topic.id, id: my_post.id}
        expect(assigns(:post)).to eq(my_post)
      end
      it "renders the #show view" do
        get :show, params: {topic_id: my_topic.id, id: my_post.id}
        expect(response).to render_template(:show)
      end
    end   # GET #show

    describe "GET #new" do
      it "returns http success" do
        get :new, params: { topic_id: my_topic.id }
        expect(response).to have_http_status(:success)
      end
      it "instantiates @post" do
        get :new, params: { topic_id: my_topic.id }
        expect(assigns(:post)).not_to be_nil
      end
      it "renders the #new view" do
        get :new, params: { topic_id: my_topic.id }
        expect(response).to render_template(:new)
      end
    end   # GET #new

    describe "POST #create" do
      it "increases the number of Post by 1" do
        expect { post :create, params: { topic_id: my_topic.id, post: {title: RandomData.random_sentence, body: RandomData.random_paragraph} }
      }.to change{Post.count}.by(1)
      end
      it "assigns the new post to @post" do
        post :create, params: { topic_id: my_topic.id, post: {title: RandomData.random_sentence, body: RandomData.random_paragraph} }
        expect(assigns(:post)).to eq(Post.last)
      end
      it "redirects to the newly created post" do
        post :create, params: { topic_id: my_topic.id, post: {title: RandomData.random_sentence, body: RandomData.random_paragraph} }
        #expect(response).to redirect_to(post_path(Post.last))
        expect(response).to redirect_to([my_topic, Post.last]) # to post show page
      end
    end   # POST #create

    describe "GET #edit" do
      it "returns http success" do
        get :edit, params: { topic_id: my_topic.id, id: my_post.id }
        expect(response).to have_http_status(:success)
      end
      it "assigns the post to be updated to @post" do
        get :edit, params: { topic_id: my_topic.id, id: my_post.id }
        post_instance = assigns(:post)

        expect(post_instance.id).to eq(my_post.id)
        expect(post_instance.title).to eq(my_post.title)
        expect(post_instance.body).to eq(my_post.body)
      end
      it "renders the edit template" do
        get :edit, params: { topic_id: my_topic.id, id: my_post.id }
        expect(response).to render_template(:edit)
      end
    end

    describe "PUT #update" do
      it "updates post with expected attributes" do
        new_title = RandomData.random_sentence
        new_body = RandomData.random_paragraph

        put :update, params: { topic_id: my_topic.id, id: my_post.id, post: { title: new_title, body: new_body } }
        updated_post = assigns(:post)

        expect(updated_post.id).to eq(my_post.id)
        expect(updated_post.title).to eq(new_title)
        expect(updated_post.body).to eq(new_body)
      end
      it "redirects to the updated post" do
        new_title = RandomData.random_sentence
        new_body = RandomData.random_paragraph

        put :update, params: { topic_id: my_topic.id, id: my_post.id, post: { title: new_title, body: new_body } }

        expect(response).to redirect_to([my_topic, my_post])
      end
    end   # PUT #update

    describe "DELETE #destroy" do
      it "deletes the post" do
        delete :destroy, params: { topic_id: my_topic.id, id: my_post.id }
        count = Post.where(id: my_post.id).size
        expect(count).to eq(0)
      end
      it "redirects to posts index view" do
        delete :destroy, params: { topic_id: my_topic.id, id: my_post.id }

        expect(response).to redirect_to(my_topic)
      end
    end   # DELETE #destroy
  end   # admin

end   # PostsController
