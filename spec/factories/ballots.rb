FactoryGirl.define do
  factory :ballot do
    semester { |ballot| ballot.course.semester }
    sequence(:exclusive) { |n| (n % 2) == 0 }

    preferences do |ballot|
      # TODO: don't use every section all the time
      ballot.course.section_ids.shuffle
    end

    student do |ballot|
      create(:student, grade: ballot.course.grade)
    end
  end
end
