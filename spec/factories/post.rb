FactoryGirl.define do
  factory :post do
    skip_create

    transient do
      user
    end

    id { SecureRandom.uuid }
    user_id { user.id }
    title { Faker::Lorem.words(6).map(&:capitalize).join(" ") }
    description { Faker::Lorem.sentence }
    image { Faker::Internet.url }

    initialize_with { Post.create(attributes) }
  end
end
