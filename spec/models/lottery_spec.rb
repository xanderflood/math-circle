require 'rails_helper'

RSpec.describe Lottery, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"

  before(:all) do
    # set up the semester
  end

  # TODO: should/could these be validations on Lottery?
  it "should produce a partition of the balloted students for each course"
  it "should produce a waitlist if there were too many ballots for the sections"
  it "should only waitlist a student if no preferred sections are available"
  it "should never waitlist a student who has priority over a student in a preferred section"
end
