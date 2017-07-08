FactoryGirl.define do
  factory :post do
    user
    title { Faker::Lorem.words(6).map(&:capitalize) }
    description { Faker::Lorem.sentence }
  end
end
