FactoryGirl.define do
  factory :post do
    title RandomData.random_sentence
    body RandomData.random_paragraph
    topic
    user
    # or   assocition :topic ; but no need  to specify assocition
    # if the factory name is the same as the assocition name
    rank 0.0
  end


end
