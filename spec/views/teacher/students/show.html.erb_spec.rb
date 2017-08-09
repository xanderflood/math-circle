require 'rails_helper'

RSpec.describe "teacher/students/show", type: :view do
  before(:each) do
    @teacher_student = assign(:teacher_student, Student.create!())
  end

  it "renders attributes in <p>" do
    render
  end
end
