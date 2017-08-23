require 'rails_helper'

RSpec.describe "parent/registrees/new", type: :view do
  before(:each) do
    assign(:parent_registree, Registree.new())
  end

  it "renders new parent_registree form" do
    render

    assert_select "form[action=?][method=?]", registrees_path, "post" do
    end
  end
end
