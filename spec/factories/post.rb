FactoryGirl.define do
  factory :post do
    user { create(:user, :publisher) }
    title { Faker::Lorem.words(6).map(&:capitalize) }
    description { Faker::Lorem.sentence }
  end
end
