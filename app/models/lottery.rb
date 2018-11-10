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

      next if registree.persisted?
      binding.pry

      registree.section_id  = ballot_info.section_id
      registree.preferences = ballot_info.preferences unless ballot_info.section_id

      errors << registree unless registree.save
    end

    if errors.any?
      message = errors.map { |reg| reg.errors.first.message }.join "\n"
      LotteryError.new(message: message).save

      return false
    end

    return true
  rescue => e
    LotteryError.save!(e)
    return false
  end

  # used only for displaying
  def to_h
    self.contents
    .group_by(&:course_id)
    .map do |course_id, course_info|
      [ course_id,
        {
          level: Course.find(course_id).level,
          enrollment: course_info.length,
          waitlist: course_info.reject(&:section_id).map(&:student_id),
          rosters: course_info.select(&:section_id)
            .group_by(&:section_id).map do |section_id, section_info|
              [section_id, section_info.map(&:student_id)]
            end.to_h
        }
      ]
    end.to_h
  end

  private
  ### callbacks ###
  # TODO: making this into a full-blown ballots-lotteries join table
  # model, backed by ActiveRecord, could simplify a lot of logic.
  # Could that be done without significant performance losses?
  BallotInfo = Struct.new(:ballot_id, :student_id, :course_id, :priority, :preferences, :section_id)
  def compute_contents
    # query the sections
    sections = EventGroup.joins(:course)
    .where('courses.semester': self.semester)

    # sort the ballots
    counts     = sections.map { |s| [s.id, s.registrees.count] }.to_h
    capacities = sections.map { |s| [s.id, s.capacity] }.to_h

    # shuffle and sort the ballots by priority
    self.contents = self.semester
    .ballots
    .includes(:student)
    .map do |b|
      reg = b.registree

      BallotInfo.new(
        b.id,
        b.student.id,
        b.course_id,
        b.student.priority,
        b.preferences,
        reg ? reg.section_id : nil)
    end
    .shuffle.sort_by(&:priority).reverse

    # make assignments, one at a time
    self.contents.each do |applicant|
      # respect existing assignments
      next if applicant.section_id

      # find the most preferred available section
      section_id = applicant.preferences.find { |p| counts[p] < capacities[p] }
      counts[section_id] += 1 if section_id

      applicant.section_id = section_id
    end
  end
end
