require 'rails_helper'

RSpec.describe "parent/registrees/new", type: :view do
  before(:each) do
    @semester = FactoryBot.create(:finished_lottery).semester
    @course = @semester.courses.first
    @section = @course.sections.first
    @student = FactoryBot.create(:student, level: @course.level)
    assign(:registree, Registree.new(
      student: @student,
      semester: @semester,
      course: @course,
      section: @section))
  end

  it "renders new parent_registree form" do
    render

    assert_select "form[action=?][method=?]", teacher_studentregistrees_path, "post" do
    end
  end
end
