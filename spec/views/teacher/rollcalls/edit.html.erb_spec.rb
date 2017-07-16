require 'rails_helper'

RSpec.describe "teacher/rollcalls/edit", type: :view do
  before(:each) do
    @teacher_rollcall = assign(:teacher_rollcall, Rollcall.create!())
  end

  it "renders the edit teacher_rollcall form" do
    render

    assert_select "form[action=?][method=?]", teacher_rollcall_path(@teacher_rollcall), "post" do
    end
  end
end
