require 'rails_helper'

RSpec.describe "parent/special_events/index", type: :view do
  before(:each) do
    assign(:special_events, [
      SpecialEvent.create!(),
      SpecialEvent.create!()
    ])
  end

  it "renders a list of parent/special_events" do
    render
  end
end
