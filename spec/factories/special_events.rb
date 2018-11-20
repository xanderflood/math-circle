FactoryBot.define do |event|
  factory :special_event do
    name { "#{rand(100000)}" }
    date { Date.today }
    start { Time.now }
    sequence(:end) { Time.now }
    description { "adfsafdafadf" }
    capacity { rand(30) }
  end
end
