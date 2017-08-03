FactoryGirl.define do
  pw = RandomData.random_sentence

  factory :user do  # factory name
    name RandomData.random_name
    sequence(:email) { |n| "user#{n}@factory.com" } # unique email using sequence
    password pw
    password_confirmation pw
    role :member
  end

end
