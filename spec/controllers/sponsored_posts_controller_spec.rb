require 'rails_helper'

RSpec.describe SponsoredPostsController, type: :controller do
  let(:my_topic) { Topic.create!(name: "Topic Name", description: "this is the topic body")}
  let(:my_sponsored_post) { my_topic.sponsored_posts.create!(title: "SponsoredPost Title", body: "this is the sponsored post body", price: 25) }

  describe "GET #show" do
    before { get :show, params: { topic_id: my_topic.id, id: my_sponsored_post.id  } }
    it "returns http success" do
      # get :show, params: { topic_id: topic.id, id: sponsored_post.id  }
      expect(response).to have_http_status(:success)
    end
    it "assigns the my_sponsored_post to @sponsored_post" do
      expect(assigns(:sponsored_post)).to eq(my_sponsored_post)
    end
    it "renders the show view" do
      expect(response).to render_template(:show)
    end
  end

  describe "GET #new" do
    before { get :new, params: { topic_id: my_topic.id, id: my_sponsored_post.id } }
    it "returns http success" do
      expect(response).to have_http_status(:success)
    end
    it "assigns a my_sponsored_post to a new @sponsored_post" do
      expect(assigns(:sponsored_post)).to_not be_nil
      expect(assigns(:sponsored_post)).to be_a_new(SponsoredPost)
    end
    it "renders the new view" do
      expect(response).to render_template(:new)
    end
  end

  describe "POST #create" do
    it "increases the number of SponsoredPost by 1" do
      expect{ post :create, params: { topic_id: my_topic.id, sponsored_post: { title: "New SponsoredPost Title", body: "this is the new sponsored post body", price: 50 } }
    }.to change{ SponsoredPost.count }.by(1)
    end
    it "assigns the my_sponsored_post to the @sponsored_post" do
      post :create, params: { topic_id: my_topic.id, sponsored_post: { title: "New SponsoredPost Title", body: "this is the new sponsored post body", price: 50 } }
      expect(assigns(:sponsored_post)).to eq(SponsoredPost.last)
    end
    it "redirects to the newly created sponsored post" do
      post :create, params: { topic_id: my_topic.id, sponsored_post: { title: "New SponsoredPost Title", body: "this is the new sponsored post body", price: 50 } }
      expect(response).to redirect_to(topic_sponsored_post_path(SponsoredPost.last.topic, SponsoredPost.last)) # OK
      expect(response).to redirect_to [SponsoredPost.last.topic, SponsoredPost.last] # OK
      expect(response).to redirect_to [my_topic, SponsoredPost.last]
    #  byebug
    end
  end

  describe "GET #edit" do
    before { get :edit, params: { topic_id: my_topic.id, id: my_sponsored_post.id } }
        #     get :edit, params: { topic_id: my_topic.id, id: my_post.id }
    it "returns http success" do
      expect(response).to have_http_status(:success)
    end
    it "assigns the sponsored_post to be updated to @sponsored_post" do
      #updated_sponsored_post = assigns(:sponsored_post)
      expect(assigns(:sponsored_post)).to eq(my_sponsored_post)
      expect(assigns(:sponsored_post).title).to eq(my_sponsored_post.title)
      expect(assigns(:sponsored_post).body).to eq(my_sponsored_post.body)
      expect(assigns(:sponsored_post).price).to eq(my_sponsored_post.price)
    end
    it "renders the new template" do
      expect(response).to render_template(:edit)
    end
  end

  describe "PUT #update" do
    before { put :update, params: { topic_id: my_topic.id, id: my_sponsored_post.id, sponsored_post: { title: "My Updated Sponsored Post Title", body: "my updated sponsored post body", price: 50 } } }
    it "updates with the expected attributes" do
      updated_sponsored_post = assigns(:sponsored_post)
      expect(updated_sponsored_post.title).to eq("My Updated Sponsored Post Title")
      expect(updated_sponsored_post.body).to eq("my updated sponsored post body")
      expect(updated_sponsored_post.price).to eq(50)

      # exploring
      expect(assigns(:sponsored_post).title).to eq("My Updated Sponsored Post Title")
      expect(updated_sponsored_post.title).to eq(my_sponsored_post.reload.title)
    end
    it "redirects to the updated sponsored_post" do
      expect(response).to redirect_to([my_topic, my_sponsored_post])
    end
  end

  describe "DELETE #destroy" do
    before { delete :destroy, params: { topic_id: my_topic.id, id: my_sponsored_post.id } }
    it "removes the selected @sponsored_post" do
      expect(SponsoredPost.where(id: my_sponsored_post).count).to eq(0)
    end
    it "redirects to the sponsored_post index view" do
      expect(response).to redirect_to(my_topic)
    end
  end

end
