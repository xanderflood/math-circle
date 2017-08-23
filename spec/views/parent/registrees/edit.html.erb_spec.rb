require 'rails_helper'

RSpec.describe "parent/registrees/edit", type: :view do
  before(:each) do
    @parent_registree = assign(:parent_registree, Registree.create!())
  end

  it "renders the edit parent_registree form" do
    render

    assert_select "form[action=?][method=?]", parent_registree_path(@parent_registree), "post" do
    end
  end
end
