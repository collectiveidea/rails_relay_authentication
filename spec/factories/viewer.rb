FactoryGirl.define do
  factory :viewer do
    skip_create

    transient { user }

    id { user.id }
    role { user.role }
    
    initialize_with { new(attributes.except(:user)) }

    trait :reader do
      transient { user { create(:user, role: "reader") } }
    end

    trait :admin do
      transient { user { create(:user, role: "admin") } }
    end
  end
end
