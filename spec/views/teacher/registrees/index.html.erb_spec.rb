require 'rails_helper'

RSpec.describe "teacher/registrees/index", type: :view do
  before(:each) do
    assign(:registrees, [
      Registree.create!(),
      Registree.create!()
    ])
  end

  it "renders a list of teacher/registrees" do
    render
  end
end
