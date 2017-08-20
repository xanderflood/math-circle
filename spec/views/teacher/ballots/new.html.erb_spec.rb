require 'rails_helper'

RSpec.describe "teacher/ballots/new", type: :view do
  before(:each) do
    @ballot = assign(:ballot, create(:ballot))
    @student = assign(:student, @ballot.student)
  end

  it "renders new teacher_ballot form" do
    render

    assert_select "form[action=?][method=?]", ballots_path, "post" do
    end
  end
end
