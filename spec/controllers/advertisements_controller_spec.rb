require 'rails_helper'

RSpec.describe AdvertisementsController, type: :controller do
  let(:my_advertisement) { Advertisement.create!(title: RandomData.random_sentence, body: RandomData.random_paragraph, price: rand(50..100)) }

  describe "GET #index" do
    before { get :index }
    it "returns http success" do
      expect(response).to have_http_status(:success)
    end
    it "assigns my_advertisement to @advertisements" do
      expect(assigns(:advertisements)).to eq([my_advertisement])
    end
    it "renders the #index template" do
      expect(response).to render_template(:index)
    end
  end   # GET #index

  describe "GET #show" do
    before { get :show, params: { id: my_advertisement.id } }
    it "returns http success" do
      expect(response).to have_http_status(:success)
    end
    it "assigns my_advertisement to @advertisement" do
      expect(assigns(:advertisement)).to eq(my_advertisement)
    end
    it "renders the #show template" do
      expect(response).to render_template(:show)
    end
  end

  describe "GET #new" do
    before { get :new }
    it "returns http success" do
      expect(response).to have_http_status(:success)
    end
    it "instantiates @advertisement" do
      expect(assigns(:advertisement)).to be_a_new(Advertisement)
    end
    it "renders the #new template" do
      expect(response).to render_template(:new)
    end
  end   # GET #new

  describe "POST #create" do
    context "with valid attributes" do
      it "increases the number of advertisements by 1" do
        expect { post :create, params: { advertisement: { title: RandomData.random_sentence, body: RandomData.random_paragraph, price: rand(50..100) } }
      }.to change{Advertisement.count}.by(1)
      end
      it "redirects to the newly created @advertisement" do
        post :create, params: { advertisement: { title: RandomData.random_sentence, body: RandomData.random_paragraph, price: rand(50..100) } }
        expect(response).to redirect_to(advertisement_path(Advertisement.last))
      #  expect(response).to redirect_to(advertisement_path(assigns(:advertisement)))
      end
    end
    context "with invalid attributes" do
      it "does not increase the number of advertisements" do
        expect{ post :create, params: { advertisement: { title: "", body: RandomData.random_paragraph, price: rand(50..100) } }
      }.to_not change(Advertisement, :count) #{ Advertisement.count }#
      end
      it "re-renders back to the new template" do
        post :create, params: { advertisement: { title: "", body: RandomData.random_paragraph, price: rand(50..100) } }
        expect(response).to render_template(:new)
      end
    end
  end   # POST #create

end
