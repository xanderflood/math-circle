require 'rails_helper'

RSpec.describe "teacher/registrees/edit", type: :view do
  before(:each) do
    @semester = FactoryGirl.create(:finished_lottery).semester
    @registree = Registree.find_by(semester: @semester)
  end

  it "renders the edit teacher_registree form" do
    render

    assert_select "form[action=?][method=?]", teacher_student_registree_path(@registree), "post" do
    end
  end
end
