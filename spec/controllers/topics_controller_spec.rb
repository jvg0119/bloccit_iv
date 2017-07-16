require 'rails_helper'

RSpec.describe TopicsController, type: :controller do
  let(:my_topic) { Topic.create!(name: RandomData.random_sentence, description: RandomData.random_paragraph) }

  describe "GET #index" do
    before { get :index }
    it "returns http success" do
      expect(response).to have_http_status(:success)
    end
    it "assigns my_topic to @topics" do
      expect(assigns(:topics)).to eq([my_topic])
    end
    it "renders the index template" do
      expect(response).to render_template(:index)
    end
  end   # GET #index

  describe "GET #show" do
    before { get :show, params: { id: my_topic.id } }
    it "returns http success" do
      expect(response).to have_http_status(:success)
    end
    it "assigns my_topic to @topic" do
      expect(assigns(:topic)).to eq(my_topic)
    end
    it "renders the show template" do
      expect(response).to render_template(:show)
    end
  end   # GET #show

  describe "GET #new" do
    before { get :new }
    it "returns http success" do
      expect(response).to have_http_status(:success)
    end
    it "assigns my_topic to a new @topic" do
      expect(assigns(:topic)).to be_a_new(Topic)
    end
    it "initializes @topic (same as above)" do
      expect(assigns(:topic)).to_not be_nil
    end
    it "renders the new template" do
      expect(response).to render_template(:new)
    end
  end   # GET #new

  describe "POST #create" do
    it "increases the number of topics by 1" do
      expect{ post :create, params: { topic: { name: RandomData.random_sentence, description: RandomData.random_paragraph } }
    }.to change{ Topic.count }.by(1)
    end
    it "assigns my_topic to the @topic" do
    # it "assigns Topic.last to @topic" do
      post :create, params: { topic: { name: RandomData.random_sentence, description: RandomData.random_paragraph } }
      expect(assigns(:topic)).to eq(Topic.last)
    end
    it "redirects to the newly created @topic" do
      post :create, params: { topic: { name: RandomData.random_sentence, description: RandomData.random_paragraph } }
      expect(response).to redirect_to(Topic.last)
    end
  end   # POST #create

  describe "GET #edit" do
    before { get :edit, params: { id: my_topic.id } }
    it "returns the http success" do
      expect(response).to have_http_status(:success)
    end
    it "assigns the selected topic to @topic" do
      expect(assigns(:topic).name).to eq(my_topic.name)
      expect(assigns(:topic).public).to eq(my_topic.public)
      expect(assigns(:topic).description).to eq(my_topic.description)
    end
    it "assigns the selected topic to @topic (same as above)" do
      updated_topic = assigns(:topic)
      expect(updated_topic.id).to eq(my_topic.id)
      expect(updated_topic.name).to eq(my_topic.name)
      expect(updated_topic.public).to eq(my_topic.public)
      expect(updated_topic.description).to eq(my_topic.description)
    end
    it "renders the edit template" do
      expect(response).to render_template(:edit)
    end
  end   # GET #edit

  describe "PUT #update" do
  #  it "assigns the my_topic to @topic" do
    it "updates topic with expected attributes" do
      put :update, params: { id: my_topic, topic: { name: RandomData.random_sentence, description: RandomData.random_paragraph } }
      updated_topic = assigns(:topic)

      expect(updated_topic.id).to eq(my_topic.id)
      expect(updated_topic.name).to eq(my_topic.reload.name)
      expect(updated_topic.public).to eq(my_topic.public)
      expect(updated_topic.description).to eq(my_topic.description)
    end
    it "updates topic with expected attributes #2" do
      new_name = RandomData.random_sentence
      new_description = RandomData.random_paragraph
      put :update, params: { id: my_topic, topic: { name: new_name, description: new_description } }
      updated_topic = assigns(:topic)

      expect(updated_topic.id).to eq(my_topic.id)
      expect(updated_topic.name).to eq(new_name)
      expect(updated_topic.description).to eq(new_description)
    end
    it "redirects to the updated topic" do
      new_name = RandomData.random_sentence
      new_description = RandomData.random_paragraph
      put :update, params: { id: my_topic, topic: { name: new_name, description: new_description } }
      #expect(response).to redirect_to(assigns(:topic)) # OK
      expect(response).to redirect_to(my_topic)
    end
  end   # PUT #update

  describe "DELETE #destroy" do
    it "removes the selected @topic" do
      my_topic
      expect{ delete :destroy, params: { id: my_topic.id }
    }.to change{Topic.count}.by(-1)
    end
    it "removes the selected @topic #2" do
      delete :destroy, params: { id: my_topic.id }
    #  expect(Topic.where(id: my_topic.id).count).to eq(0)
      expect(Topic.where(id: my_topic.id).count).to be_zero
    end
    it "redirects to the topic index page" do
      delete :destroy, params: { id: my_topic.id }
      expect(response).to redirect_to(topics_path)
    end
  end   # DELETE #destroy

end
