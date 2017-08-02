require 'rails_helper'

RSpec.describe "parent/profiles/show", type: :view do
  before(:each) do
    @parent_profile = assign(:parent_profile, ParentProfile.create!())
  end

  it "renders attributes in <p>" do
    render
  end
end
