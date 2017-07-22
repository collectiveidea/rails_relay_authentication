FactoryGirl.define do
  factory :post, class: API::Post do
    skip_create

    transient do
      user
    end

    creatorId { user.id }
    title { Faker::Lorem.words(6).map(&:capitalize).join(" ") }
    description { Faker::Lorem.sentence }
    image {
      ActionDispatch::Http::UploadedFile.new(tempfile: Tempfile.new('image1.jpg'), filename:  "my_image.jpg")      
    }

    initialize_with { API::CreatePost.call(attributes.except(:user)).post }
  end
end
