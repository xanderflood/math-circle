require 'rails_helper'

RSpec.describe "teacher/students/edit", type: :view do
  before(:each) do
    @teacher_student = assign(:teacher_student, Student.create!())
  end

  it "renders the edit teacher_student form" do
    render

    assert_select "form[action=?][method=?]", teacher_student_path(@teacher_student), "post" do
    end
  end
end
