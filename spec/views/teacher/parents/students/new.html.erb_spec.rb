require 'rails_helper'

RSpec.describe "teacher/parents/new", type: :view do
  before(:each) do
    assign(:teacher_parent, Student.new())
  end

  it "renders new teacher_parent form" do
    render

    assert_select "form[action=?][method=?]", students_path, "post" do
    end
  end
end
