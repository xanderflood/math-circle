class Lottery < ApplicationRecord
  belongs_to :semester

  serialize :contents, Hash

  before_create :compute_contents

  ### methods ###
  def commit
    errors = []

    self.contents.each do |student_id, section_id|
      ballot    = Ballot.find_by(student_id: student_id)
      registree = ballot.registree_or_new

      registree.section_id  = section_id
      registree.preferences = ballot.preferences unless section_id

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
    lottery_hash = {}
    self.semester.courses.each do |course|
      lottery_hash[course.id] = { waitlist: [], rosters: {} }

      course.section_ids.each do |section_id|
        lottery_hash[course.id][:rosters][section_id] = []
      end
    end

    self.contents.each do |student_id, section_id|
      if section_id
        course_id = EventGroup.find(section_id).course_id
        lottery_hash[course_id][:rosters][section_id] << student_id
      else
        course_id = Student.find(student_id).ballot(semester).course_id
        lottery_hash[course_id][:waitlist] << student_id
      end
    end

    lottery_hash
  end

  private
  ### callbacks ###
  BallotInfo = Struct.new(:student_id, :course_id, :priority, :preferences, :section_id)
  def compute_contents
    # queries
    capacities = EventGroup.joins(:course)
                 .where('courses.semester': self.semester)
                 .map { |s| [s.id, s.capacity] }.to_h

    ballot_infos = Ballot.where(semester: self.semester)
    .includes(:student).map do |b|
      BallotInfo.new(b.student.id,
                     b.course_id,
                     b.student.priority,
                     b.preferences,
                     nil)
    end
    .sort_by{ |bi| [-bi.priority, rand] }
    .group_by(&:course_id)

    # do the lottery
    counts = Hash.new 0
    self.contents = {}
    rosters = ballot_infos.map do |course_id, applicants|

      applicants.map do |a|
        enrolled = false

        section_id = a.preferences.find { |p| counts[p] < capacities[p] }
        counts[section_id] += 1 if section_id

        self.contents[a.student_id] = section_id
      end
    end.inject([], :+)
  end
end
