require 'rails_helper'

RSpec.describe "teacher/registrees/new", type: :view do
  before(:each) do
    assign(:teacher_registree, Registree.new())
  end

  it "renders new teacher_registree form" do
    render

    assert_select "form[action=?][method=?]", registrees_path, "post" do
    end
  end
end
