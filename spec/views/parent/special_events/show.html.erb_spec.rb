require 'rails_helper'

RSpec.describe "parent/special_events/show", type: :view do
  before(:each) do
    @parent_special_event = assign(:parent_special_event, SpecialEvent.create!())
  end

  it "renders attributes in <p>" do
    render
  end
end
