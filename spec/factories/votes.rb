FactoryGirl.define do
  factory :vote do
    value 1
    user
    post

    factory :down_vote, class: :vote do
      value -1
    end
  end

end
