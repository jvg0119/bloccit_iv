require 'rails_helper'

RSpec.describe PostsController, type: :controller do
  #let(:my_post) { Post.create!(title: "old title", body: RandomData.random_paragraph) }
  let(:my_topic) { Topic.create!(name: RandomData.random_sentence, description: RandomData.random_paragraph) }
  let(:my_post) { my_topic.posts.create!(title: RandomData.random_sentence, body: RandomData.random_paragraph) }


  # not needed anymore because this will be displayed under topic show
  # describe "GET #index" do
  #   it "returns http success" do
  #     get :index
  #     expect(response).to have_http_status(:success)
  #   end
  #   it "assigns the my_post to @posts" do
  #     get :index
  #     expect(assigns(:posts)).to eq([my_post])
  #   end
  #   it "renders the #index view" do
  #     get :index
  #     expect(response).to render_template(:index)
  #   end
  # end   # GET #index

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

  end

  describe "GET #new" do
    it "returns http success" do
      get :new, params: { topic_id: my_topic.id }
      expect(response).to have_http_status(:success)
    end
    it "assigns a new post to @post" do
      get :new, params: { topic_id: my_topic.id }
      expect(assigns(:post)).to be_a_new(Post)
    end
    it "instantiates @post" do
      get :new, params: { topic_id: my_topic.id }
      expect(assigns(:post)).not_to be_nil
    end
    it "renders the #new view" do
      get :new, params: { topic_id: my_topic.id }
      expect(response).to render_template(:new)
    end
  end

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
      expect(response).to redirect_to([my_topic, Post.last])
    end
  end   # POST #create

  describe "GET #edit" do
    it "returns http success" do
      get :edit, params: { topic_id: my_topic.id, id: my_post.id }
      expect(response).to have_http_status(:success)
    end
    it "assigns the post to be updated to @post" do
      get :edit, params: { topic_id: my_topic.id, id: my_post.id }
      expect(assigns(:post).id).to eq(my_post.id)
      expect(assigns(:post).title).to eq(my_post.title)
      expect(assigns(:post).body).to eq(my_post.body)
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
      # expect(response).to redirect_to(post_path(assigns(:post))) # OK
      # expect(response).to redirect_to(post_path(my_post)) # OK
      expect(response).to redirect_to([my_topic, my_post]) # shortcut for the above
    end
  end   # PUT #update

  describe "DELETE #destroy" do
    # it "removes the selected @post" do  # works
    # #my_post
    #   expect{ delete :destroy, params: { id: my_post.id }
    # }.to change{Post.count}.by(-1)
    # end

    it "removes the selected @post #1" do
      delete :destroy, params: { topic_id: my_topic.id, id: my_post.id }
      expect(Post.where(id: my_post.id).size).to be_zero
    end
    it "removes the selected @post #2" do
      delete :destroy, params: { topic_id: my_topic.id, id: my_post.id }
      count = Post.where(id: my_post.id).size
      expect(count).to eq(0)
    end
    it "redirects to posts index view" do
      delete :destroy, params: { topic_id: my_topic.id, id: my_post.id }
      #expect(response).to redirect_to(posts_path) # not nested
      # expect(response).to redirect_to(topic_path(my_topic)) # long way
      expect(response).to redirect_to(my_topic) # shortcut
    end
  end   # DELETE #destroy


end
