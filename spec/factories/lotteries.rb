FactoryGirl.define do
  factory :lottery do
    semester { FactoryGirl.create(:semester_for_lottery) }
    contents { }
  end
end
