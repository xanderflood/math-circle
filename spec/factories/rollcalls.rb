FactoryBot.define do
  factory :rollcall do
    date { Date.today }

    event do 
      semester = create(:semester_with_courses)

      semester.courses.first
        .sections.first
        .events.first
    end
  end
end
