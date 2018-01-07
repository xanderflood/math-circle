class Lottery < ApplicationRecord
  belongs_to :semester

  serialize :contents, Array

  before_create :compute_contents

  ### methods ###
  def commit
    errors = []

    ballots = Ballot.find(self.contents.map(&:ballot_id)).group_by(&:id)
    self.contents.each do |ballot_info|
      ballot    = ballots[ballot_info.ballot_id].first
      registree = ballot.registree_or_new

      registree.section_id  = ballot_info.section_id
      registree.preferences = ballot_info.preferences unless ballot_info.section_id

      errors << registree unless registree.save
    end

    if errors.any?
      message = errors.map { |reg| reg.errors.first.message }.join "\n"
      LotteryError.new(message: message).save

      return :some_errors
    end

    return true
  rescue => e
    LotteryError.save!(e)
    return false
  end

  def to_h
    h = self.contents
    .group_by(&:course_id)
    .map do |course_id, course_info|
      [ course_id,
        {
          enrollment: course_info.length,
          waitlist: course_info.reject(&:section_id).map(&:student_id),
          rosters: course_info.select(&:section_id)
                  .group_by(&:section_id).map do |section_id, section_info|
                    [section_id, section_info.map(&:student_id)]
                  end.to_h
        }]
    end.to_h

    h
  end

  private
  ### callbacks ###
  # TODO: making this into a full-blown ballots-lotteries join table
  # model, backed by ActiveRecord, could simplify a lot of logic.
  # Could that be done without significant performance losses?
  BallotInfo = Struct.new(:ballot_id, :student_id, :course_id, :priority, :preferences, :section_id)
  def compute_contents
    # query the database and sort the ballots
    counts     = Hash.new 0
    capacities = EventGroup.joins(:course)
                 .where('courses.semester': self.semester)
                 .map { |s| [s.id, s.capacity] }.to_h

    self.contents = Ballot.where(semester: self.semester)
    .includes(:student).map do |b|
      BallotInfo.new(b.id,
                     b.student.id,
                     b.course_id,
                     b.student.priority,
                     b.preferences,
                     nil)
    end
    .sort_by{ |bi| [-bi.priority, rand] }

    # do the lottery
    self.contents.each do |applicant|
      enrolled = false

      section_id = applicant.preferences.find { |p| counts[p] < capacities[p] }
      counts[section_id] += 1 if section_id

      applicant.section_id = section_id
    end
  end
end
