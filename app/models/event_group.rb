class EventGroup < ApplicationRecord
  default_scope{ order(created_at: :desc)}

  after_save :populate_events

  has_many :events, foreign_key: :section_id
  belongs_to :course

  # TODO: Add validations and code to create all the child events

  enum wday: DayHelper::DAYS

  # TODO: This is weird, but Rails complains if the section isn't saved before the events
  def populate_events
    if self.wday
      sem = self.course.semester
      schedule = IceCube::Schedule.new(start = sem.start, end_date: sem.end) do |s|
        s.add_recurrence_rule(IceCube::Rule.weekly.day(self.wday.to_sym))
      end

      schedule.occurrences_between(sem.start, sem.end).each do |occ|
        self.events.build(name: @name, when: occ.to_date, time: occ.to_time).save!
      end
    end
  end

  def time_str
    I18n.l self[:time]
  end

  def description
    if name.empty?
      "#{wday} @ #{time_str}"
    else
      "#{name} - #{wday} @ #{time_str}"
    end
  end
end
