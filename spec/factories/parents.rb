FactoryBot.define do
  factory :parent do
    email { "parent#{rand(10000000000)}@sheinhartwigs.com" }
    password "password"

    after(:create) do |parent|
      create(:parent_profile, parent: parent)
    end
  end
end
