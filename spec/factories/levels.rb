FactoryBot.define do
  factory :level do
    name { "#{rand(10000000)}" }
    active { true }
  end
end
