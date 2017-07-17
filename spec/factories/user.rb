FactoryGirl.define do
  factory :user do
    skip_create

    id { SecureRandom.uuid }
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.first_name }
    email { Faker::Internet.email }
    password  "password123"
    password_digest { BCrypt::Password.create(password) }
    role "publisher"
    authentication_token { nil }

    initialize_with { Datastore::User::Create.call(attributes) }

    trait :reader do
      role "reader"
    end

    trait :admin do
      role "admin"
    end
  end
end
