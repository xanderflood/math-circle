require 'rails_helper'

RSpec.describe "teacher/registrees/edit", type: :view do
  before(:each) do
    @semester = FactoryGirl.create(:finished_lottery).semester
    @registree = Registree.find_by(semester: @semester)
    @student = @registree.student
  end

  it "renders the edit teacher_registree form" do
    render

    assert_select "form[action=?][method=?]", teacher_student_registree_path(@student), "post" do
    end
  end
end
