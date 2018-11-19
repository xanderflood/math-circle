FactoryBot.define do
  factory :lottery do
    semester { FactoryBot.create(:semester_for_lottery, name: "Semster with lottery done") }

    factory(:finished_lottery) do
      after(:create) do |lottery|
        lottery.commit
      end
    end
  end
end
