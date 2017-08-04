require 'rails_helper'

RSpec.describe Comment, type: :model do
  # let(:post) { Post.create!(title: "My Post Title", body: "My post body") }
  # let(:comment) { post.comments.create!(body: "My comment body") }

  #let(:user) {  User.create!(name: "Bloccit User", email: "user@bloccit.com", password: "helloworld")}
  #let(:user) { create(:user, name: "Bloccit User", email: "user@bloccit.com", password: "helloworld" ) }
  #let(:topic) { Topic.create!(name: RandomData.random_sentence, description: RandomData.random_paragraph) }
  #let(:post) { topic.posts.create!(title: RandomData.random_sentence, body: RandomData.random_paragraph) }
  #let(:post) { topic.posts.create!(title: RandomData.random_sentence, body: RandomData.random_paragraph, user: user) }

  let(:user) { create(:user)}
  let(:topic) { create(:topic) }
  let(:post) { create(:post) }
  #let(:comment) { Comment.create!(body: "my comment body", post: post) }
  #let(:comment) { Comment.create!( body: "my comment body", post: post, user: user ) }
  let(:comment) { create(:comment) }

  # test belongs to user & post
  it { is_expected.to belong_to(:post) }
  it { is_expected.to belong_to(:user) }

  # test comment validations
  it {  is_expected.to validate_presence_of(:body) }
  it { is_expected.to validate_length_of(:body).is_at_least(5) }

  describe "attributes" do
    it "has a body attribute" do
      #expect(comment).to have_attributes(body: "my comment body", post: post, user: user)
      expect(comment).to have_attributes(body: comment.body, post: comment.post, user: comment.user)
    end
  end


# we want to send an email every time a user comments on a favorited post, let's add a callback to Comment

  describe "#after_create" do
    before do
      @another_comment = Comment.new(body: "this is another comment.", user: user, post: post) # initialized but not saved @another_comment
    end
    it "sends email to users who have favorited the post" do
      favorite = user.favorites.create(post: post) # this user favorited this post
      expect(FavoriteMailer).to receive(:new_comment).with(user, post, @another_comment).and_return(double(deliver_now: true))
      # expect(FavoriteMailer).to receive(:new_comment).with(user, post, @another_comment)#.{deliver_now}
      # :new_comment  is the method that will be called by FavoriteMailer (FavoriteMailer.new_comment)
      # .with(user, post, @antoher_comment)  will be required for the :new_comment to work
      # .and_return(double(deliver_now: true)  this is stubbing deliver_now  so it will not make the actual delivery if test is setup
      # if not stubbed it will return an error:
      #   NoMethodError:   undefined method `deliver_now' for nil:NilClass
      # because the favorite is not saved yet (it's still nil)
      @another_comment.save!  # save will trigger the expected behavior
    end
    it "does not send emails to users who have not favorited the post" do
      expect(FavoriteMailer).not_to receive(:new_comment)
        # here FavoriteMailer will not receive :new_comment because the post was not favorited by the user
      @another_comment.save!
    end
  end


end
