require 'rails_helper'

RSpec.describe "teacher/students/index", type: :view do
  before(:each) do
    assign(:students, [
      Student.create!(),
      Student.create!()
    ])
  end

  it "renders a list of teacher/students" do
    render
  end
end
