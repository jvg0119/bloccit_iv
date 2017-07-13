require 'rails_helper'

RSpec.describe PostsController, type: :controller do
  let(:my_post) { Post.create!(title: RandomData.random_sentence, body: RandomData.random_paragraph) }

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


  # describe "GET #edit" do
  #   it "returns http success" do
  #     get :edit
  #     expect(response).to have_http_status(:success)
  #   end
  # end


end
