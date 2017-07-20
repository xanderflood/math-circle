FactoryGirl.define do
  factory :parent do
    sequence(:email) { |n| "parent#{n}@sheinhartwigs.com" }
    password "password"
  end
end
