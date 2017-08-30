require 'rails_helper'

RSpec.describe "teacher/parents/edit", type: :view do
  before(:each) do
    @teacher_parent = assign(:teacher_parent, Parent.create!())
  end

  it "renders the edit teacher_parent form" do
    render

    assert_select "form[action=?][method=?]", teacher_parent_path(@teacher_parent), "post" do
    end
  end
end
