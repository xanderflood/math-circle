FactoryGirl.define do
  factory :student do
    grade :A
    email "person@email.com"

    sequence(:first_name) { |n| "Henderleigh-#{n}" }
    sequence(:last_name) { |n| ["McNabb", "Trufflestein", "Kombucha", "Cookbook"].sample }

    priority { rand(30) }
    parent { create(:parent) }
  end
end
