class Course < ApplicationRecord
  default_scope{ order(created_at: :desc) }

  belongs_to :semester
  has_many :sections, class_name: "EventGroup"
  has_many :ballots

  validates :level, presence:  { allow_blank: false, message: "must be specified." },
                    exclusion: { in: ['unspecified'], message: "must be specified." }

  enum level: LevelsHelper::LEVELS

  ### methods ###
  def roster
    @roster ||= self.sections.map(&:roster).inject([], :+)
  end

  def waitlist
    @waitlist ||= Registree.where(course: self, section: nil).includes(:student).map(&:student)
  end

  def all_students
    @all_students ||= roster + waitlist
  end

  def description
    if name
      "#{name} (level #{level})"
    else
      "level #{level}"
    end
  end
end
