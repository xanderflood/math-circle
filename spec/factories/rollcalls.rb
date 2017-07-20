FactoryGirl.define do
  factory :rollcall do
    date Date.today

    event do 
      semester = create(:semester_With_courses)

      semester.courses.first
        .sections.first
        .events.first
    end
  end
end
