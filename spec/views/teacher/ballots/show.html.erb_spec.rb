require 'rails_helper'

RSpec.describe "teacher/ballots/show", type: :view do
  before(:each) do
    @ballot = assign(:ballot, create(:ballot))
    @student = assign(:student, @ballot.student)
  end

  it "renders attributes in <p>" do
    render
  end
end
