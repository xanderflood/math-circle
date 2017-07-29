class Lottery < ApplicationRecord
  belongs_to :semester

  after_initialize :set_course_rosters
  before_save :populate_contents
  serialize :contents, Hash

  class CourseRoster
    attr_accessor :id

    def initialize(course)
      @course        = course
      self.id        = course.id
      @waitlist      = []
      @open_sections = course.sections.select { |s| s.capacity != 0 }.map(&:id)

      @section_rosters = course.sections.map do |section|
        [section.id, SectionRoster.new(section)]
      end.to_h

      # run the lottery:
      add_all_students
    end

    def add_all_students
      # sort descending by priority, break ties randomly
      @course.ballots.all.sort_by do |ballot|
        [-ballot.student.priority, rand]
      end.each { |ballot| add_student(ballot) }
    end

    def add_student(ballot)
      section_id = (@open_sections & ballot.preferences).first

      if section_id
        if @section_rosters[section_id].add_student(ballot.student_id)
          @open_sections.delete(section_id)
        end
      else
        @waitlist << ballot.student_id
      end
    end

    def to_h
      {
        rosters: @section_rosters.map { |id, sr| [id, sr.roster] }.to_h,
        waitlist: @waitlist
      }
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
      self.roster << student_id

      @space -= 1
      return @space == 0
    end
  end

  #### class logic

  def run
    @course_rosters = self.semester.courses.map do |course|
      CourseRoster.new(course)
    end
  end

  def populate_contents
    self.contents = @course_rosters.map do |cr|
      [cr.id, cr.to_h]
    end.to_h
  end

  def commit
    section_updates = []
    course_updates = self.contents.map do |course_id, course|
      section_updates += course[:rosters].map do |section_id, roster|
        [section_id, { roster: roster }]
      end

      [course_id, { waitlist: course[:waitlist] }]
    end.to_h

    section_updates = section_updates.to_h

    courses  = Course.update(course_updates.keys, course_updates.values)
    sections = EventGroup.update(section_updates.keys, section_updates.values)
    self.semester.update!(state: :late_reg)

    errored_courses  = courses.select   { |c| c.errors.count != 0 }
    errored_sections = sections.select { |s| s.errors.count != 0 }
    errored          = errored_courses | errored_sections

    if errored.any?
      message = errored.map { |obj| obj.errors.first.message }.join "\n"
      LotteryError.new(message: message).save

      return :some_errors
    end

    return true
  rescue => e
    LotteryError.save!(e)
    return false
  end

  protected
    def set_course_rosters
      @course_rosters ||= []
    end
end