require 'rails_helper'

RSpec.describe "teacher/rollcalls/edit", type: :view do
  before(:each) do
    @rollcall = assign(:rollcall, FactoryGirl.create(:rollcall))
  end

  it "renders the edit teacher_rollcall form" do
    binding.pry
    render

    assert_select "form[action=?][method=?]", teacher_rollcall_path(@teacher_rollcall), "post" do
    end
  end
end
