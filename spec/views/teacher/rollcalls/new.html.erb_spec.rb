require 'rails_helper'

RSpec.describe "teacher/rollcalls/new", type: :view do
  before(:each) do
    assign(:teacher_rollcall, Rollcall.new())
  end

  it "renders new teacher_rollcall form" do
    render

    assert_select "form[action=?][method=?]", rollcalls_path, "post" do
    end
  end
end
