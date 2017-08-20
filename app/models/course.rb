class Course < ApplicationRecord
  default_scope{ order(created_at: :desc) }

  belongs_to :semester
  has_many :sections, class_name: "EventGroup"
  has_many :ballots

  serialize :waitlist, Array

  # TODO: unrequire "name" and replace with a "description" method
  validates :level, presence:  { allow_blank: false, message: "must be specified." },
                    exclusion: { in: ['unspecified'], message: "must be specified." }

  enum level: LevelsHelper::LEVELS

  def roster
    self.sections.map(&:roster).inject([], :+)
  end

  def waitlist
    self.sections.map(&:waitlist).inject([], :+)
  end

  def all_students
    self.sections.map(&:all_students).inject([], :+)
  end

  def description
    if name
      "#{name} (level #{level})"
    else
      "level #{level}"
    end
  end
end
