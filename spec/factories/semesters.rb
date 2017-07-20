FactoryGirl.define do
  factory :semester do
    name "Spring 2017"
    start "2017-01-12"
    self.end "2017-05-30"
    state :prereg

    trait(:for_lottery) do
      current true

      # courses
      after(:create) do |semester|
        create_list(:course_with_ballots, 4,
          semester: semester)
      end
    end

    factory :semester_for_lotto, traits: [:for_lottery]
  end
end
