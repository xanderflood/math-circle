require 'rails_helper'

RSpec.describe Lottery, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"

  before(:all) do
    # set up the semester
    @lottery  = FactoryGirl.build(:lottery)
    @lottery.run_lottery
  end

  # TODO: should/could these be validations on Lottery?
  it "should produce a partition of the balloted students for each course" do
    @lottery.semester.courses.each do |course|
      balloted_students = Ballot.where(course: course).all.map(&:student_id).sort

      enrolled_students = (course.sections.map(&:roster).inject([], :+) + course.waitlist).sort

      expect(balloted_students).to eq enrolled_students

      # & the section rosters together and sort it, and check that it equals
      # the list of ballot student ids
    end
  end

  it "should produce a waitlist if there were too many ballots for the sections"
  it "should only waitlist a student if no preferred sections are available"
  it "should never waitlist a student who has priority over a student in a preferred section"
end
