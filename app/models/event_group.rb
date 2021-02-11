class EventGroup < ApplicationRecord
  default_scope{ order(created_at: :desc)}

  belongs_to :course, required: true
  has_many :events, foreign_key: :section_id, dependent: :destroy
  has_many :registrees, foreign_key: :section_id, dependent: :destroy
  has_many :rollcalls, through: :events

  after_initialize :copy_course_capacity, if: :new_record?
  after_create :populate_events

  validates :wday,
    presence: { allow_blank: false, message: "must be specified"}
  validates :event_time, on: :create,
    presence: { allow_blank: false, message: "must be specified"}

  after_update :shift

  attr_accessor :event_time

  enum wday: DayHelper::DAYS

  ### methods ###
  # presentation
  def time_str
    I18n.l self.time
  end

  #TODO: remove EventGroup#name entirely - it's stupid
  # deprecate it and create a notification channel to see if it's ever used?
  def name
    self.course.description
  end

  def time
    e = self.events.first
    e.time if e
  end

  def description
    if name.nil? || name.empty?
      "#{wday} @ #{time_str}"
    else
      "#{name} - #{wday} @ #{time_str}"
    end
  end

  # enrollment
  def full?; roster.count >= capacity; end
  def space; capacity - roster.count; end

  def roster
    @roster = Registree.where(section: self).includes(:student).map(&:student)
  end

  def waitlist
    self.course.waitlist_registrees.select { |reg| reg.preferences.include? self.id }
  end

  def shift
    Registree.transaction do
      self.waitlist.limit(self.space).update(section_id: self.id)
    end
  rescue
  end

  def attendance_file_name
    if name.nil? || name.empty?
      "#{wday}_#{time_str}.csv"
    else
      "#{name}_#{wday}_#{time_str}.csv"
    end
  end

  def attendance_headers
    header = ["Student", "Student ID", "Total"] +
              self.rollcalls.map(&:event).map(&:when).map(&:to_s)
  end

  # for attendance CSV
  #TODO: this logic is duplicated somewhat in
  # Rollcall.attendance_table. The semantics are
  # different, but the underlying calculation
  # should be de-duped
  def attendance_rows
    students = self.roster | self.rollcalls.map(&:student_ids).inject([], :|)
               .map { |i| Student.find(i) }
    students = students.sort_by(&:sorting_name)

    students.map do |student|
      record = self.rollcalls.map do |rollcall|
        AttendanceHelper::STATES[rollcall.attendance_hash[student.id] || 1]
      end
      total = record.count do |status|
        AttendanceHelper::PRESENT_ISH.include?(status)
      end

      [student.name, student.id, total] + record
    end
  end

  ### callbacks ###
  protected
  def copy_course_capacity
    capacity ||= course.capacity if course
  end

  def populate_events
    if self.wday
      sem = self.course.semester
      schedule = IceCube::Schedule.new(sem.start, end_date: sem.end) do |s|
        s.add_recurrence_rule(IceCube::Rule.weekly.day(self.wday.to_sym))
      end

      schedule.occurrences_between(sem.start, sem.end).each do |occ|
        self.events.build(name: @name, when: occ.to_date, time: self.event_time).save!
      end
    end
  end
end
