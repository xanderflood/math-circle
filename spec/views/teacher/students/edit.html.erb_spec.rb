require 'rails_helper'

RSpec.describe "teacher/students/edit", type: :view do
  before(:each) do
    @student = assign(:student, create(:student))
  end

  it "renders the edit teacher_student form" do
    render

    assert_select "form[action=?][method=?]", teacher_student_path(@student), "post" do
    end
  end
end
