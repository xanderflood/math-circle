FactoryGirl.define do
  factory :student do
    level :A
    sequence(:email) { |n| "student#{n}@email.com" }

    sequence(:first_name) { |n| "Henderleigh-#{n}" }
    sequence(:last_name) { |n| ["McNabb", "Trufflestein", "Kombucha", "Cookbook"].sample }

    birthdate { Date.today }
    waiver_submitted true

    school_grade(10)

    priority { rand(30) }
    parent { create(:parent) }
  end
end
