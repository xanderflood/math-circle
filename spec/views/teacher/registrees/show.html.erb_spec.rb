require 'rails_helper'

RSpec.describe "teacher/registrees/show", type: :view do
  before(:each) do
    @teacher_registree = assign(:teacher_registree, Registree.create!())
  end

  it "renders attributes in <p>" do
    render
  end
end
