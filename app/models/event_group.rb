require 'csv'

class EventGroup < ApplicationRecord
  default_scope{ order(created_at: :desc)}

  belongs_to :course
  has_many :events, foreign_key: :section_id, dependent: :destroy
  has_many :registrees, foreign_key: :section_id, dependent: :destroy
  has_many :rollcalls, through: :events

  after_initialize :copy_course_capacity, if: :new_record?
  after_create :populate_events

  validates :wday, presence: { allow_blank: false, message: "must be specified"}
  validates :time, presence: { allow_blank: false, message: "must be specified"}

  enum wday: DayHelper::DAYS

  ### methods ###
  def full?; roster.count >= capacity; end
  def space; roster.count - capacity; end

  def time_str
    I18n.l self[:time]
  end

  def rollcalls
    events.map(&:rollcall).compact
  end

  def roster
    binding.pry
    @roster = Registree.where(section: self).includes(:student).map(&:student)
  end

  def waitlist
    self.course.waitlist_registrees.select { |reg| reg.preferences.include? self.id }
  end

  def description
    if name.nil? || name.empty?
      "#{wday} @ #{time_str}"
    else
      "#{name} - #{wday} @ #{time_str}"
    end
  end

  def attendance_file_name
    if name.nil? || name.empty?
      "#{wday}_#{time_str}.csv"
    else
      "#{name}_#{wday}_#{time_str}.csv"
    end
  end

  def attendance_csv_data
    rollcall_list = rollcalls

    students = rollcall_list.map(&:student_ids).inject([], :|).
                map { |i| Student.find(i) }.sort_by(&:sorting_name)

    header = ["Student", "Student ID", "Total"] +
              rollcall_list.map(&:event).map(&:when).map(&:to_s)
    output = CSV.generate_line(header)
    students.each do |student|
      record = rollcall_list.map do |rollcall|
        val = rollcall.attendance_hash[student.id] || 1 #default to absent

        AttendanceHelper::STATES[val]
      end
      total = record.count { |status| AttendanceHelper::PRESENT_ISH.include?(status) }

      output << CSV.generate_line([student.name, student.id, total] + record)
    end

    output
  end

  def shift
    Registree.transaction do
      self.waitlist.limit(self.space).update(section_id: self.id)
    end
  rescue
  end

  ### callbacks ###
  protected
  def copy_course_capacity
    capacity = course.capacity if course
  end

  def populate_events
    if self.wday
      sem = self.course.semester
      schedule = IceCube::Schedule.new(start = sem.start, end_date: sem.end) do |s|
        s.add_recurrence_rule(IceCube::Rule.weekly.day(self.wday.to_sym))
      end

      schedule.occurrences_between(sem.start, sem.end).each do |occ|
        self.events.build(name: @name, when: occ.to_date, time: self.time).save!
      end
    end
  end
end
