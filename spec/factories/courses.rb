FactoryGirl.define do
  factory(:course) do
    semester nil
    name "MyString"
    overview "MyText"
    sequence(:grade) { |n| n % Course.grades.count }

    # sections
    after(:create) do |course|
      # this will be used to sequence the other attributes
      offset = 1 + Course.grades[course.grade]

      create_list(:event_group, offset,
        course: course,
        capacity: 5*offset,
        wday: (Date.today.wday + offset) % 7)
    end

    trait(:ballots) do
      after(:create) do |course|
        # generate between 5 and cap+5 students
        total_capcaity = course.sections.map(&:capacity).inject(:+)
        num_applicants = 5 + rand(total_capcaity)

        create_list(:ballot, num_applicants,
          course: course)
      end
    end

    factory :course_with_ballots, traits: [:ballots]
  end
end
