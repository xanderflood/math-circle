FactoryGirl.define do
  factory :student do
    grade :A
    email "person@email.com"
    sequence(:name) do |n|
      surname = ["McNabb", "Trufflestein", "Kombucha", "Cookbook"].sample
      "Henderleigh #{n} #{surname}"
    end

    priority { rand(30) }
    parent { create(:parent) }
  end
end
