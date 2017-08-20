require 'rails_helper'

RSpec.describe "teacher/ballots/edit", type: :view do
  before(:each) do
    @ballot = assign(:ballot, create(:ballot))
    @student = assign(:student, @ballot.student)
  end

  it "renders the edit teacher_ballot form" do
    render

    assert_select "form[action=?][method=?]", teacher_ballot_path(@teacher_ballot), "post" do
    end
  end
end
