FactoryGirl.define do
  factory :viewer do
    transient do
      user
    end
    
    initialize_with { new(uuid: user.uuid, role: user.role) }
  end
end
