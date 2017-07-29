FactoryGirl.define do
  factory :student do
    email "person@email.com"
    sequence(:name) { |n| "henderleigh #{n}" }

    priority { rand(30) }
    parent { create(:parent) }
  end
end
