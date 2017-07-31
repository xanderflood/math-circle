FactoryGirl.define do
  factory :semester do
    sequence(:name) { |n| "Spring #{2017 + n}" }
    sequence(:start) { |n| "#{2017 + n}-01-12" }
    sequence(:end) { |n| "#{2017 + n}-05-30" }
    state :reg

    trait(:for_lottery) do
      current true

      after(:create) do |semester|
        create_list(:course_with_ballots, 4, semester: semester)
      end
    end

    trait(:courses) do
      after(:create) do |semester|
        create_list(:course, 4, semester: semester)
      end
    end

    factory :semester_for_lottery, traits: [:for_lottery]
    factory :semester_with_courses, traits: [:courses]
  end
end
