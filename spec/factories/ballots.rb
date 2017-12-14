FactoryGirl.define do
  factory :ballot do
    initialize_with do
      student = FactoryGirl.create(:student, level: attributes[:course].level)
      new(attributes.merge({ student: student }))
    end

    semester { |ballot| ballot.course.semester }

    preferences do |ballot|
      sis = ballot.course.section_ids
      sis.first(rand(1..sis.count)).shuffle
    end
  end
end
