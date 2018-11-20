FactoryBot.define do
  factory :event_group do
    name { "" }
    course
    event_time { "5:00 pm" }
    sequence(:wday) { |n| (Date.today.wday + n) % 7 }
    capacity { 10 }
  end
end
