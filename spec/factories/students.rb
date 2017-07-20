FactoryGirl.define do
  factory :student do
    sequence(:name) { |n| "henderleigh #{n}" }

    priority { rand(30) }
    parent { create(:parent) }
  end
end
