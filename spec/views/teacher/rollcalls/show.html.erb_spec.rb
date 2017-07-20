require 'rails_helper'

RSpec.describe "teacher/rollcalls/show", type: :view do
  before(:each) do
    @rollcall = FactoryGirl.create(:rollcall)
  end

  it "renders attributes in <p>" do
    render
  end
end
