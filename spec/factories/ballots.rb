FactoryGirl.define do
  factory :ballot do
    initialize_with do
      student = FactoryGirl.create(:student, level: attributes[:level])
      new(attributes.merge({ student: student }))
    end

    semester { |ballot| ballot.course.semester }

    preferences do |ballot|
      # TODO: don't use every section all the time
      ballot.course.section_ids.shuffle
    end
  end
end
