FactoryGirl.define do
  factory :user, class: API::User do
    skip_create

    firstName { Faker::Name.first_name }
    lastName { Faker::Name.first_name }
    email { Faker::Internet.email }
    password  "password123"
    role "publisher"

    initialize_with {
      API::Register.call(attributes).user
    }

    trait :reader do
      role "reader"
    end

    trait :admin do
      role "admin"
    end
  end
end
