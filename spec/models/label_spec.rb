require 'rails_helper'

RSpec.describe Label, type: :model do

  # let(:topic) { Topic.create!(name: RandomData.random_sentence, description: RandomData.random_paragraph) }
  # let(:user) { User.create!(name: "Bloccit User", email: "user@bloccit.com", password: "password") }
  # let(:post) { topic.posts.create!(title: RandomData.random_sentence, body: RandomData.random_paragraph, user: user)}

  let(:topic) { create(:topic) }
  let(:user) { create(:user) }
  let(:post) { create(:post) }


  let(:label) { Label.create!(name: 'Label') }
  let(:label2) {  Label.create!(name: 'Label2')}


  # a label should have_many labelings
  # a labeling could be either a topic or a post (our polymorphic relationships).
  # this test will only pass after creating the labeling.rb model
  # and adding    belongs_to :labelable, polymorphic: true
  # also you may need to run     bin/rake db:test:prepare   to setup the test environment
  # just running the      bin/rails db:migrate RAILS_ENV=test    as suggested   is not enough
  # bin/rake db:test:prepare     does all the env setup; no need for db:migrate RAILS_ENV=test
  it { is_expected.to have_many(:labelings) }

  # a label should have_many topics and posts through  labelings
  # these 2 below will pass after creating model label.rb and adding the has_many ...
  it { is_expected.to have_many(:topics).through(:labelings) }
  it { is_expected.to have_many(:posts).through(:labelings) }

  describe "labelings" do
    it "allows the same label to be associated with a different topic and post" do
      topic.labels << label
      post.labels << label

      topic_label = topic.labels[0]
      post_label = post.labels[0]

      expect(topic_label).to eql(post_label)
    end
  end

  describe ".update_labels" do
    it "takes a comma delimited string and returns an array of labels" do
      labels = "#{label.name}, #{label2.name}" # this creates the space; so the it needs the .strip method to remove the space
    #  labels = "#{label.name},#{label2.name}" # this will not need the .strip
      labels_as_a = [label, label2]

      expect(Label.update_labels(labels)).to eq(labels_as_a)
    end
  end

end
