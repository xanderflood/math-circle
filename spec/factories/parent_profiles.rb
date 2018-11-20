FactoryBot.define do
  factory :parent_profile do
    initialize_with do
      attributes[:parent] = create(:parent) unless attributes.key? :parent
      new(attributes)
    end

    first_name { "#{rand}Parent" }
    last_name { "#{rand}McParentus" }

    phone { "248-555-5555" }

    street1 { "1600 Pennsylvania Ave" }
    street2 { "" }
    city { "Washington" }
    state { "DC" }
    zip { "20500" }

    ec1_first_name { "test" }
    ec1_last_name { "test" }
    ec1_relation { "test" }
    ec1_phone { "248-555-5555" }
    ec2_first_name { "test" }
    ec2_last_name { "test" }
    ec2_relation { "test" }
    ec2_phone { "248-555-5555" }

    parent
  end
end
