require 'rails_helper'

RSpec.describe "parent/special_events/new", type: :view do
  before(:each) do
    assign(:parent_special_event, SpecialEvent.new())
  end

  it "renders new parent_special_event form" do
    render

    assert_select "form[action=?][method=?]", special_events_path, "post" do
    end
  end
end
