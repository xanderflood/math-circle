require 'rails_helper'

RSpec.describe "parent/profiles/edit", type: :view do
  before(:each) do
    @parent_profile = assign(:parent_profile, create(:parent_profile))
  end

  it "renders the edit parent_profile form" do
    render

    assert_select "form[action=?][method=?]", parent_profile_path(@parent_profile), "post" do
    end
  end
end
