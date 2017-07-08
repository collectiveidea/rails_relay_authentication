FactoryGirl.define do
  factory :viewer do
    transient { user }

    uuid { user.uuid }
    role { user.role }
    
    initialize_with { new(attributes) }
  end

  trait :reader do
    transient { user { create(:user, role: :reader) } }
  end

  trait :admin do
    transient { user { create(:user, role: :admin) } }
  end

end
