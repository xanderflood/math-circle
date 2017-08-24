class Lottery < ApplicationRecord
  belongs_to :semester

  serialize :contents, Hash

  after_initialize :run, if: :new_record?

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

  protected
  ### lottery logic ###
  class CourseRoster
    attr_accessor :id

    def initialize(course)
      @course        = course
      self.id        = course.id
      @waitlist      = []

      @section_rosters = course.sections.map do |section|
        [section.id, SectionRoster.new(section)]
      end.to_h

      # sort descending by priority, break ties randomly
      @course.ballots.all.sort_by do |ballot|
        [-ballot.student.priority, rand]
      end.each { |ballot| add_student(ballot) }
    end

    def add_student(ballot)
      enrolled = false
      ballot.preferences.each do |pref|
        enrolled = @section_rosters[pref].add_student(ballot.student_id)

        break if enrolled
      end

      @waitlist << ballot.student_id unless enrolled
    end

    def to_h
      enrolled = @section_rosters.each do |id, sr|
        sr.roster.map{ |student| [student, section_id] }
      end.inject([], :+)

      Hash[enrolled + @waitlist.map{ |w| [w, nil] }]
    end
  end

  class SectionRoster
    attr_accessor :roster

    def initialize(section)
      @section    = section
      self.roster = []
      @space      = section.capacity
    end

    # this should not be called if @section is already full
    def add_student(student_id)
      return false unless @space > 0

      self.roster << student_id
      @space -= 1
      return true
    end
  end

  ### callbacks ###
  def run
    @course_rosters = self.semester.courses.map do |course|
      CourseRoster.new(course)
    end

    self.contents = @course_rosters.map(&:to_h).inject([], :+)
  end
end
