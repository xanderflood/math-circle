FactoryGirl.define do
  factory(:course) do
    sequence(:grade) { |n| n % Course.grades.count }

    name { "Level #{self.grade}" }
    overview { "Super cool math funstuff for ages"\
               "#{self.grade} through #{self.grade}" }

    # sections
    after(:create) do |course|
      # this will be used to sequence the other attributes
      offset = 1 + Course.grades[course.grade]

      create_list(:event_group, offset,
        course: course,
        capacity: 30 + 2*offset)
    end

    trait(:ballots) do
      after(:create) do |course|
        # generate between cap-5 and 2cap students
        total_capacity = course.sections.map(&:capacity).inject(:+)
        num_applicants = (total_capacity - 5) + rand(20)

        create_list(:ballot, num_applicants,
          course: course,
          semester: course.semester)
      end
    end

    factory :course_with_ballots, traits: [:ballots]
  end
end
