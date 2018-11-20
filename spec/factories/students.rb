FactoryBot.define do
  factory :student do
    sequence(:email) { |n| "student#{n}@email.com" }
    sequence(:first_name) { |n| "Henderleigh-#{n}" }
    sequence(:last_name) { |n| ["McNabb", "Trufflestein", "Kombucha", "Cookbook"].sample }

    parent
    birthdate { Date.today }
    waiver_submitted { true }

    priority { rand(2) }
    school_grade { 10 }
    level { Level.random || create(:level)  }
  end
end
