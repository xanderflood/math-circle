require 'rails_helper'

RSpec.describe Lottery, type: :model do
  before(:all) do
    @lottery = FactoryGirl.create(:finished_lottery)
    @semester = @lottery.semester

    # If this fails because lottery is nil, you have to `rake db:seed RAILS_ENV=test`
    @ballots = @lottery.semester.courses.collect do |course|
      [course.id, course.ballots]
    end.to_h
  end

  # TODO: should/could these be validations on Lottery?
  it "should produce a partition of the balloted students for each course" do
    @lottery.semester.courses.each do |course|
      balloted_students = @ballots[course.id].map(&:student_id).sort

      enrolled_students = (course.sections.map(&:roster).inject([], :+) + course.waitlist).sort

      expect(balloted_students).to eq enrolled_students.map(&:id)
    end
  end

  it "should produce a waitlist if there were too many ballots for the sections" do
    @lottery.semester.courses.each do |course|
      applicants     = @ballots[course.id].count
      total_capacity = course.sections.map(&:capacity).inject(0, :+)

      expect(course.waitlist.count).to be > 0 if applicants > total_capacity
    end
  end

  it "should only waitlist a student if no preferred sections are available" do
    @lottery.semester.courses.each do |course|
      course.waitlist do |student_id|
        ballot = Ballot.find(student_id: student_id, semester_id: @lottery.semester.id)

        ballot.preferences.each do |section|
          expect(section.capacity).to eq section.roster.count
        end
      end
    end
  end

  it "should never waitlist a student who has priority over a student in a preferred section" do
    @lottery.semester.courses.each do |course|
      course.waitlist do |student_id|
        ballot = Ballot.find(student_id: student_id, semester_id: @lottery.semester.id)

        ballot.preferences.each do |section|
          expect(section.capacity).to eq section.roster.count
        end
      end
    end
  end
end
