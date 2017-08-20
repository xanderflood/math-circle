require 'rails_helper'

RSpec.describe "teacher/students/index", type: :view do
  before(:each) do
    assign(:students, Student.paginate(page: 1, per_page: 3))
  end

  it "renders a list of teacher/students" do
    render
  end
end
