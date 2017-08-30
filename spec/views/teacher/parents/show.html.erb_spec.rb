require 'rails_helper'

RSpec.describe "teacher/parents/show", type: :view do
  before(:each) do
    @teacher_parent = assign(:teacher_parent, Parent.create!())
  end

  it "renders attributes in <p>" do
    render
  end
end
