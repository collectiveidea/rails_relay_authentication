FactoryGirl.define do
  factory :user do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.first_name }
    email { Faker::Internet.email }
    password  "password123"
    role :publisher

    trait :reader do
      role :reader
    end

    trait :admin do
      role :admin
    end
  end
end
