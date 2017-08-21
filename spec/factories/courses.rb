FactoryGirl.define do
  factory(:course) do
    sequence(:level) { |n| 1 + (n % (Course.levels.count-1)) }

    name { "Level #{self.level}" }
    overview { "Super cool math funstuff for ages"\
               "#{self.level} through #{self.level}" }

    # sections
    after(:create) do |course|
      # this will be used to sequence the other attributes
      offset = 1 + Course.levels[course.level]

      create_list(:event_group, offset,
        course: course,
        capacity: course.capacity)
    end

    trait(:ballots) do
      after(:create) do |course|
        # generate between cap-5 and 2cap students
        total_capacity = course.sections.map(&:capacity).inject(:+)
        num_applicants = (total_capacity - 1) + rand(3)

        create_list(:ballot, num_applicants, course: course)
      end
    end

    factory :course_with_ballots, traits: [:ballots]
  end
end
