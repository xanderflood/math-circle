FactoryGirl.define do
  factory :parent do
    sequence(:email) { |n| "parent#{rand 1_000_000}@sheinhartwigs.com" }
    password "password"
  end
end
