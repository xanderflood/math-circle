class EventGroup < ApplicationRecord
  default_scope{ order(created_at: :desc)}

  has_many :events, foreign_key: :section_id
  belongs_to :course

  serialize :waitlist, Array
  serialize :roster,   Array

  before_save  :shift_waitlist
  after_create :populate_events

  validates :wday, presence: { allow_blank: false, message: "must be specified"}
  validates :time, presence: { allow_blank: false, message: "must be specified"}
  validate :list_formats
  validate :not_over_full

  enum wday: DayHelper::DAYS

  # TODO: Add validations and code to create all the child events

  def full?
    roster.count == capacity
  end

  # TODO: inform teachers that force-adding a student -permenantly- increases the capacity of the section
  # mode is one of normal, force (bump capacity if full) and skip (return true if full)
  def add_student(student, mode=nil)
    # binding.pry
    if full?
      return false  if mode == :skip
      capacity += 1 if mode == :force
    end

    if full?
      waitlist << student.id
    else
      roster   << student.id
    end
    return true

    # TODO: NOTIFY
  end

  # TODO: This is weird, but Rails complains if the section isn't saved before the events
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

  def not_over_full
    # TODO: should check a force flag somewhere/somehow
    errors.add(:roster, "exceeds the capacity for this section") unless roster.count <= capacity
  end

  def list_formats
    [[waitlist, :waitlist], [roster, :roster]].each do |l|
      errors.add(l[1], "is not formatted properly.") unless
        l[0].all? { |s| s.is_a? Integer }
    end
  end

  def shift_waitlist
    shifted = []
    shifted << waitlist.shift until full? || waitlist.empty?

    self.roster += shifted
    # TODO: NOTIFY shifted students
  end

  def time_str
    I18n.l self[:time]
  end

  def description
    if name.nil? || name.empty?
      "#{wday} @ #{time_str}"
    else
      "#{name} - #{wday} @ #{time_str}"
    end
  end
end
