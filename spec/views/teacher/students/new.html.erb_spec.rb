require 'rails_helper'

RSpec.describe "teacher/students/new", type: :view do
  before(:each) do
    assign(:teacher_student, Student.new())
  end

  it "renders new teacher_student form" do
    render

    assert_select "form[action=?][method=?]", students_path, "post" do
    end
  end
end
