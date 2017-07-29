FactoryGirl.define do
  factory :student do
    email "person@email.com"
    sequence(:name) do |n|
      SURNAMES = ["McNabb", "Trufflestein", "Kombucha", "Cookbook"]
      "Henderleigh #{n} #{SURNAMES.sample}"
    end

    priority { rand(30) }
    parent { create(:parent) }
  end
end
