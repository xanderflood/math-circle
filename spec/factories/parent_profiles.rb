FactoryGirl.define do
  factory :parent_profile do
    parent { create(:parent) }
  end
end
