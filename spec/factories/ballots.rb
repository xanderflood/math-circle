FactoryGirl.define do
  factory :ballot do
    course nil
    tudent nil
    semester nil
    preferences "MyText"
    exclusive false
  end
end
