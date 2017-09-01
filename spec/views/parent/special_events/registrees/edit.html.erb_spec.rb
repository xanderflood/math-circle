require 'rails_helper'

RSpec.describe "parent/special_events/edit", type: :view do
  before(:each) do
    @parent_special_event = assign(:parent_special_event, SpecialRegistree.create!())
  end

  it "renders the edit parent_special_event form" do
    render

    assert_select "form[action=?][method=?]", parent_special_event_path(@parent_special_event), "post" do
    end
  end
end
