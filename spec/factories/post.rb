FactoryGirl.define do
  factory :post do
    user
    title { Faker::Lorem.words(6).map(&:capitalize).join(" ") }
    description { Faker::Lorem.sentence }
    image { Faker::Internet.url }
  end
end
