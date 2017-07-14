require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:my_question) { Question.create!(title:"My Question Title", body:"my question body", resolved: false) }

  describe "GET #index" do
    before { get :index }
    it "returns http success" do
      expect(response).to have_http_status(:success)
    end
    it "assigns my_question to @questions" do
      expect(assigns(:questions)).to eq([my_question])
    end
    it "renders the index template" do
      expect(response).to render_template(:index)
    end
  end

  describe "GET #show" do
    before { get :show, params: { id: my_question.id } }
    it "returns http success" do
      expect(response).to have_http_status(:success)
    end
    it "assigns my_question to @question" do
      expect(assigns(:question)).to eq(my_question)
    end
    it "renders the show template" do
      expect(response).to render_template(:show)
    end
  end

  describe "GET #new" do
    before { get :new }
    it "returns http success" do
      expect(response).to have_http_status(:success)
    end
    it "assigns a new question to @question" do
      expect(assigns(:question)).to be_a_new(Question)
      expect(assigns(:question)).not_to be_nil
    end
    it "renders the new template" do
      expect(response).to render_template(:new)
    end
  end

  describe "POST #create" do
    it "increases the number of questions by 1" do
      expect{ post :create, params: { question: { title:"My New Question Title", body:"my new question body" } }
    }.to change{Question.count}.by(1)
    end
    it "assigns the new question to @question" do
      post :create, params: { question: { title:"My New Question Title", body:"my new question body" } }
      expect(assigns(:question)).to eq(Question.last)
      expect(assigns(:question).title).to eq("My New Question Title")
    end
    it "redirects to the newly created question show view" do
      post :create, params: { question: { title:"My New Question Title", body:"my new question body" } }
      expect(response).to redirect_to(Question.last)
    end
  end

  describe "GET #edit" do
    before { get :edit, params: { id: my_question } }
    it "returns http success" do
      expect(response).to have_http_status(:success)
    end
    it "assigns the requested question to @question" do
      updated_question = assigns(:question)
      expect(updated_question.id).to eq(my_question.id)
      expect(updated_question.title).to eq(my_question.title)
      expect(updated_question.body).to eq(my_question.body)
    end
    it "renders the edit template" do
      expect(response).to render_template(:edit)
    end
  end

  describe "PUT #update" do
    it "updates the question with expected attributes" do
      put :update, params: { id: my_question.id, question: { title:"Updated Question Title", body:"updated question body", resolved: true } }
      expect(assigns(:question).title).to eq("Updated Question Title") # this is OK
      expect(assigns(:question).body).to eq("updated question body")
    #  expect(assigns(:question).title).to eq(my_question.title) # this will fail
      expect(assigns(:question).title).to eq(my_question.reload.title) # it needs to be reladed
                                                          # it retains it's value until reloaded
    end
    it "redirects to the updated question" do
      put :update, params: { id: my_question.id, question: { title:"Updated Question Title", body:"updated question body", resolved: true } }
      expect(response).to redirect_to(assigns(:question))
    end
  end
  describe "PUT #update (using a different method)" do
    it "updates the question with expected attributes" do
      question_title = RandomData.random_sentence
      question_body = RandomData.random_paragraph
      put :update, params: { id: my_question.id, question: { title: question_title, body: question_body } }
      updated_question = assigns(:question)

      expect(updated_question.id).to eq(my_question.id)
      expect(updated_question.title).to eq(question_title)
      expect(updated_question.body).to eq(question_body)
    end
  end
  



end
