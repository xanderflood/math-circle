class Course < ApplicationRecord
  default_scope{ order(created_at: :desc) }

  # TODO: how does editing capacity work, for
  # both courses and sections?

  belongs_to :semester
  has_many :sections, dependent: :destroy, class_name: "EventGroup"
  has_many :ballots, dependent: :destroy
  has_many :registrees, dependent: :destroy

  belongs_to :level

  after_update :shift

  ### methods ###
  def roster
    @roster ||= self.sections.map(&:roster).inject([], :+)
  end

  def waitlist_registrees
    @waitlist_registrees ||= Registree.where(course: self, section: nil)
                             .joins(:student)
                             .order("students.priority DESC", updated_at: :asc)
  end

  def waitlist
    @waitlist ||= waitlist_registrees.map(&:student)
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

  # this is a callback, but also a public method
  def shift; self.sections.each(&:shift); end
end
