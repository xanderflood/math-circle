FactoryGirl.define do
  factory :ballot do
    initialize_with do
      student = FactoryGirl.create(:student, level: attributes[:course].level)
      new(attributes.merge({ student: student }))
    end

    semester { |ballot| ballot.course.semester }

    preferences do |ballot|
      bs = ballot.course.section_ids.shuffle
      bs.first(rand(bs.count - 2) + 1)
    end
  end
end
