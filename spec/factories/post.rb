FactoryGirl.define do
  factory :post, class: API::Post do
    skip_create

    transient do
      viewer
    end

    creatorId { viewer.id }
    title { Faker::Lorem.words(6).map(&:capitalize).join(" ") }
    description { Faker::Lorem.sentence }
    sequence(:image) do |n|
      ActionDispatch::Http::UploadedFile.new(
        tempfile: Tempfile.new('image1.jpg'), 
        filename:  "my_image_#{n}.jpg"
      )      
    end

    initialize_with { API::CreatePost.call(attributes).post }
  end
end
