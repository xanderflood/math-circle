require 'rails_helper'

RSpec.describe "teacher/registrees/edit", type: :view do
  before(:each) do
    @registree = assign(:registree, Registree.where.not(section: nil).limit(1).first)
  end

  it "renders the edit teacher_registree form" do
    render

    assert_select "form[action=?][method=?]", teacher_student_registree_path(@registree), "post" do
    end
  end
end
