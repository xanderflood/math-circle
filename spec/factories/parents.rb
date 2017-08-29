FactoryGirl.define do
  factory :parent do
    sequence(:email) { |n| "parent#{rand(2**(0.size * 8 -2) -1)}@sheinhartwigs.com" }
    password "password"

    after(:create) do |parent|
      create(:parent_profile, parent: parent)
    end
  end
end
