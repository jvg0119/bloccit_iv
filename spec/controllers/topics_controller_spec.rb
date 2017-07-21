require 'rails_helper'
include SessionsHelper

RSpec.describe TopicsController, type: :controller do
  let(:my_topic) { Topic.create!(name: RandomData.random_sentence, description: RandomData.random_paragraph) }

# ====================
# guest
  context "guest" do
    describe "GET #index" do
      before { get :index }
      it "returns http success" do
        expect(response).to have_http_status(:success)
      end
      it "assigns Topic.all to @topics" do
        expect(assigns(:topics)).to eq([my_topic])
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

# guest cannot create, update or destroy topics; restricted then redirected to new_session_path or sign in page
    describe "GET #new" do
      it "returns http redirect" do
        get :new
        expect(response).to redirect_to(new_session_path)
      end
    end   # GET #new

    describe "POST #create" do
      it "returns http redirect" do
        post :create, params: { topic: { name: RandomData.random_sentence, description: RandomData.random_paragraph } }
        expect(response).to redirect_to(new_session_path)
      end
    end   # POST #create

    describe "GET #edit" do
      it "returns http redirect" do
        get :update, params: { id: my_topic.id }
        expect(response).to redirect_to(new_session_path)
      end
    end   # PUT #edit

    describe "PUT #update" do
      it "returns http redirect" do
        new_name = RandomData.random_sentence
        new_discription = RandomData.random_paragraph
        put :update, params: { id: my_topic.id, topic: { name: new_name, description: new_discription } }

        expect(response).to redirect_to(new_session_path)
      end
    end

    describe "DELETE #destroy" do
      it "returns http redirect" do
        delete :destroy, params: { id: my_topic.id }
        expect(response).to redirect_to(new_session_path)
      end
    end
  end   # guest

# ====================
# member
  context "member" do
    before do
      user = User.create!(name: "Bloccit User", email: "user@Bloccit.com", password: "password", role: :member)
      create_session(user)
    end

    describe "GET #index" do
      before { get :index }
      it "returns http success" do
        expect(response).to have_http_status(:success)
      end
      it "assigns Topic.all to @topics" do
        expect(assigns(:topics)).to eq([my_topic])
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

# member cannot create, update or destroy topics; restricted then redirected to topics_path or topic index page
    describe "GET #new" do
      it "returns http redirect" do
        get :new
        expect(response).to redirect_to(topics_path)
      end
    end   # GET #new

    describe "POST #create" do
      it "returns http redirect" do
        post :create, params: { topic: { name: RandomData.random_sentence, description: RandomData.random_paragraph } }
        expect(response).to redirect_to(topics_path)
      end
    end   # POST #create

    describe "GET #edit" do
      it "returns http redirect" do
        get :update, params: { id: my_topic.id }
        expect(response).to redirect_to(topics_path)
      end
    end   # PUT #edit

    describe "PUT #update" do
      it "returns http redirect" do
        new_name = RandomData.random_sentence
        new_discription = RandomData.random_paragraph
        put :update, params: { id: my_topic.id, topic: { name: new_name, description: new_discription } }

        expect(response).to redirect_to(topics_path)
      end
    end

    describe "DELETE #destroy" do
      it "returns http redirect" do
        delete :destroy, params: { id: my_topic.id }
        expect(response).to redirect_to(topics_path)
      end
    end
  end   # member


# ====================
# assignment cp 40 Authorization
# moderator  Can update, but not create or delete, existing topics.
  context "moderator" do
    before do
      user = User.create!(name: "Bloccit User", email: "user@Bloccit.com", password: "password", role: :moderator)
      create_session(user)
    end

    describe "GET #index" do  # same as member & guest
      before { get :index }
      it "returns http success" do
        expect(response).to have_http_status(:success)
      end
      it "assigns Topic.all to @topics" do
        expect(assigns(:topics)).to eq([my_topic])
      end
    end   # GET #index

    describe "GET #show" do   # same as member & guest
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

    describe "GET #new" do   # redirects to topics index; he's already signed in
      it "returns http redirect" do
        get :new
        expect(response).to redirect_to(topics_path)
      end
    end   # GET #new

    describe "POST #create" do  # redirects to topics index; he's already signed in
      it "returns http redirect" do
        post :create, params: { topic: { name: RandomData.random_sentence, description: RandomData.random_paragraph } }
        expect(response).to redirect_to(topics_path)
      end
    end   # POST #create

    describe "GET #edit" do   # moderator can do this action; same as admin
      before { get :edit, params: { id: my_topic.id } }
      it "returns the http success" do
        expect(response).to have_http_status(:success)
      end
      it "assigns topic to be updated to @topic" do
        topic_instance = assigns(:topic)

        expect(topic_instance.id).to eq(my_topic.id)
        expect(topic_instance.name).to eq(my_topic.name)
        # expect(topic_instance.public).to eq(my_topic.public)
        expect(topic_instance.description).to eq(my_topic.description)
      end
      it "renders the edit template" do
        expect(response).to render_template(:edit)
      end
    end   # GET #edit

    describe "PUT #update" do   # moderator can do this action; same as admin 
      it "updates topic with expected attributes" do
        new_name = RandomData.random_sentence
        new_description = RandomData.random_paragraph
        put :update, params: { id: my_topic.id, topic: { name: new_name, description: new_description } }
        updated_topic = assigns(:topic)

        expect(updated_topic.id).to eq(my_topic.id)
        expect(updated_topic.name).to eq(new_name)
        expect(updated_topic.description).to eq(new_description)
      end
      it "redirects to the updated topic" do
        new_name = RandomData.random_sentence
        new_description = RandomData.random_paragraph
        put :update, params: { id: my_topic.id, topic: { name: new_name, description: new_description } }
        #expect(response).to redirect_to(assigns(:topic)) # OK
        expect(response).to redirect_to(my_topic)
      end
    end   # PUT #update

    describe "DELETE #destroy" do # redirects to topics index; he's already signed in
      it "returns http redirect" do
        delete :destroy, params: { id: my_topic.id }
        expect(response).to redirect_to(topics_path)
      end
    end   # DELETE #destroy
  end   # moderator


# ====================
# admin
  context "admin" do
    before do
      user = User.create!(name: "Bloccit User", email: "user@Bloccit.com", password: "password", role: :admin)
      create_session(user)
    end

    describe "GET #index" do
      before { get :index }
      it "returns http success" do
        expect(response).to have_http_status(:success)
      end
      it "assigns Topic.all to @topics" do
        expect(assigns(:topics)).to eq([my_topic])
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
      it "initializes @topic" do
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
      it "assigns Topic.last to the @topic" do
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
      it "assigns topic to be updated to @topic" do
        topic_instance = assigns(:topic)

        expect(topic_instance.id).to eq(my_topic.id)
        expect(topic_instance.name).to eq(my_topic.name)
        # expect(topic_instance.public).to eq(my_topic.public)
        expect(topic_instance.description).to eq(my_topic.description)
      end
      it "renders the edit template" do
        expect(response).to render_template(:edit)
      end
    end   # GET #edit

    describe "PUT #update" do
      it "updates topic with expected attributes" do
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
        count = Topic.where(id: my_topic.id).size
        expect(count).to eq(0)
      end
      it "redirects to the topic index page" do
        delete :destroy, params: { id: my_topic.id }
        expect(response).to redirect_to(topics_path)
      end
    end   # DELETE #destroy
  end   # admin

end   # TopicsController
