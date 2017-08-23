require 'rails_helper'

RSpec.describe "teacher/registrees/edit", type: :view do
  before(:each) do
    @teacher_registree = assign(:teacher_registree, Registree.create!())
  end

  it "renders the edit teacher_registree form" do
    render

    assert_select "form[action=?][method=?]", teacher_registree_path(@teacher_registree), "post" do
    end
  end
end
