FactoryGirl.define do
  factory :semester do
    name "Spring 2016"
    start "2017-01-12"
    self.end "2017-05-30"
    state :hidden

    trait(:for_lottery) do
      state :lottery_open

      after(:create) do |semester|
        create_list(:course_with_ballots, 4, semester: semester)
      end
    end

    trait(:courses) do
      state :lottery_open

      after(:create) do |semester|
        create_list(:course, 4, semester: semester)
      end
    end

    factory :semester_for_lottery, traits: [:for_lottery]
    factory :semester_with_courses, traits: [:courses]
  end
end
