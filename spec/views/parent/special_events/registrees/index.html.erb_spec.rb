require 'rails_helper'

RSpec.describe "parent/special_events/index", type: :view do
  before(:each) do
    assign(:special_registrees, [
      SpecialRegistree.create!(),
      SpecialRegistree.create!()
    ])
  end

  it "renders a list of parent/special_events" do
    render
  end
end
