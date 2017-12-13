FactoryGirl.define do
  factory :lottery do
    semester { FactoryGirl.create(:semester_for_lottery, name: "Semster with lottery done") }

    trait(:execution) do
      after(:create) do |lottery|
        lottery.commit
      end
    end

    factory :finished_lottery, traits: [:execution]
  end
end
