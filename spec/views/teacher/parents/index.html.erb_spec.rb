require 'rails_helper'

RSpec.describe "teacher/parents/index", type: :view do
  before(:each) do
    assign(:parents, [
      Parent.create!(),
      Parent.create!()
    ])
  end

  it "renders a list of teacher/parents" do
    render
  end
end
