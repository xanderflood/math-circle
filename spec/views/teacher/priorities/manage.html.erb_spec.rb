require 'rails_helper'

RSpec.describe "teacher/priorities/manage.html.erb", type: :view do
  it "renders the reset-priorities form" do
    render

    assert_select "form[action=?][method=?]", priorities_reset_teacher_semesters_path, "post" do
      assert_select "input[name=threshold][step=1][min=0][type=number]"
    end
  end
end
