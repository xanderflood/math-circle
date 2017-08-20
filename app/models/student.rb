class Student < ApplicationRecord
  belongs_to :parent
  has_many :ballots

  enum level: LevelsHelper::LEVELS

  after_update :maybe_clear_ballot

  validates_format_of :email, with: EmailHelper::OPTIONAL_EMAIL
  validates :birthdate, presence: true
  validates :waiver_submitted, inclusion: {
      in: [true],
      message: "Please confirm that you've submitted a waiver with WaiverForever."
    }
  validates :school_grade, numericality: {
      only_integer: true,
      greater_than_or_equal_to: 1,
      less_than_or_equal_to: 12
    }

  def maybe_clear_ballot
    if self.school_grade_changed? || self.level_changed?
      self.ballot.destroy if self.ballot
    end
  end

  def section
    semester = Semester.current
    @section ||= semester ? semester.sections.all.find { |section| section.roster.include?(id) } : nil
  end

  def name
    [self.first_name, self.last_name].join " "
  end

  def name=(val)
    parts = val.split " "
    self.first_name = parts.first
    self.last_name  = parts.last
  end

  # put the last name first for sorting purposes
  def sorting_name
    [self.last_name, self.first_name].join " "
  end

  def waitlist_course
    semester = Semester.current
    @waitlist_course ||= semester ? semester.courses.all.find { |course| course.waitlist.include?(id) } : nil
  end

  def waitlisted?
    !self.waitlist_course.nil?
  end

  def waitlist_position
    self.waitlist_course.waitlist.index(id) if waitlisted?
  end

  def registered?
    semester = Semester.current
    return false if semester.nil?

    semester.ballots.where(student_id: id).first
  end

  def enrolled?
    !section.nil?
  end

  def attendance_count(semester=Semester.current)
    section.events.map(&:rollcall).compact.count { |rc| rc.present_ih?(self.id) }
  end

  def ballot
    @ballot ||= Ballot.where(student: self, semester: Semester.current).first
  end
end
