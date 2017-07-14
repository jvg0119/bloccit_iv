# original
require 'rails_helper'

RSpec.describe PostsController, type: :controller do
#  let(:my_post) { Post.create!(title: RandomData.random_sentence, body: RandomData.random_paragraph) }
  let(:my_post) { Post.create!(title: "old title", body: RandomData.random_paragraph) }

  describe "GET #index" do
    it "returns http success" do
      get :index
      expect(response).to have_http_status(:success)
    end
    it "assigns the my_post to @posts" do
      get :index
      expect(assigns(:posts)).to eq([my_post])
    end
    it "renders the #index view" do
      get :index
      expect(response).to render_template(:index)
    end
  end   # GET #index

  describe "GET #show" do
    it "returns http success" do
      get :show, params: {id: my_post.id}
      expect(response).to have_http_status(:success)
    end
    it "assigns my_post to @post" do
      get :show, params: {id: my_post.id}
      expect(assigns(:post)).to eq(my_post)
    end
    it "renders the #show view" do
      get :show, params: {id: my_post.id}
      expect(response).to render_template(:show)
    end

  end

  describe "GET #new" do
    it "returns http success" do
      get :new
      expect(response).to have_http_status(:success)
    end
    it "assigns a new post to @post" do
      get :new
      expect(assigns(:post)).to be_a_new(Post)
    end
    it "instantiates @post" do
      get :new
      expect(assigns(:post)).not_to be_nil
    end
    it "renders the #new view" do
      get :new
      expect(response).to render_template(:new)
    end
  end

  describe "POST #create" do
    it "increases the number of Post by 1" do
      expect { post :create, params: { post: {title: RandomData.random_sentence, body: RandomData.random_paragraph} }
    }.to change{Post.count}.by(1)
    end
    it "assigns the new post to @post" do
      post :create, params: { post: {title: RandomData.random_sentence, body: RandomData.random_paragraph} }
      expect(assigns(:post)).to eq(Post.last)
    end
    it "redirects to the newly created post" do
      post :create, params: { post: {title: RandomData.random_sentence, body: RandomData.random_paragraph} }
      expect(response).to redirect_to(post_path(Post.last))
    end
  end   # POST #create

  describe "GET #edit" do
    it "returns http success" do
      get :edit, params: { id: my_post.id }
      expect(response).to have_http_status(:success)
    end
    it "assigns the post to be updated to @post" do
      get :edit, params: { id: my_post.id }
      expect(assigns(:post).id).to eq(my_post.id)
      expect(assigns(:post).title).to eq(my_post.title)
      expect(assigns(:post).body).to eq(my_post.body)
    end
    it "renders the edit template" do
      get :edit, params: { id: my_post.id }
      expect(response).to render_template(:edit)
    end
  end

  describe "PUT #update" do
    it "updates post with expected attributes" do
      p "my_post = #{my_post.title}"
      new_title = "new title"#RandomData.random_sentence
      new_body = RandomData.random_paragraph
      put :update, params: { id: my_post.id, post: { title: new_title, body: new_body } }
      updated_post = assigns(:post)
      expect(updated_post.id).to eq(my_post.id)
      expect(updated_post.title).to eq(new_title)
      expect(updated_post.body).to eq(new_body)
      expect(updated_post.title).to eq("new title")
  #    expect(updated_post).to eq(my_post) # this is passing
  #   expect(updated_post.title).to eq(my_post.reload) # this is failing
      expect(updated_post.title).to eq(my_post.reload.title) # add .reload to make it pass
      # my_post keeps its values until you perform the .reload  on it
      # then it will show the updated value
      # that's the reason why update_post.title != my_post.title

      p "id - #{my_post.id}"
      p updated_post.id == my_post.id
      p "id - #{updated_post.id}"
      p updated_post == my_post
      p "my_post.title = #{my_post.title}"
      p "updated_post.title = #{updated_post.title}"
      p my_post.body

    #  expect(updated_post.body).to eq(my_post.body)
    end
    it "redirects to the updated post" do
      new_title = RandomData.random_sentence
      new_body = RandomData.random_paragraph
      put :update, params: { id: my_post.id, post: { title: new_title, body: new_body } }
      expect(response).to redirect_to(post_path(assigns(:my_post)))
    end
  end   # PUT #update


end
