FactoryGirl.define do
  factory :lottery do
    semester { FactoryGirl.create(:semester_for_lottery, name: "Semster with lottery done") }
    contents { }
  end
end
