class Student < ApplicationRecord
  belongs_to :parent

  has_many :ballots, dependent: :destroy
  has_many :registrees, dependent: :destroy

  enum level: LevelsHelper::LEVELS

  attr_accessor :waiver_force

  after_update :maybe_clear_ballot

  validates_format_of :email, with: EmailHelper::OPTIONAL_EMAIL
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :birthdate, presence: true
  validates :waiver_submitted, inclusion: {
      in: [true],
      message: "is required"
    }, unless: :waiver_force
  validates :school_grade, numericality: {
      only_integer: true,
      greater_than_or_equal_to: 1,
      less_than_or_equal_to: 12
    }

  ### non-rails associations ###
  def ballot(semester=Semester.current)
    @ballot ||= Ballot.find_by(student: self, semester: semester)
  end

  def enrollment_status
    if self.registree
      if self.registree.section
        "#{self.registree.course.name} - #{self.registree.section.description}"
      else
        "#{self.registree.course.name} - waitlist"
      end
    else
      "Not registered"
    end
  end

  def registree(semester=Semester.current)
    @registree ||= Registree.find_by(student: self, semester: semester)
  end

  #
  # TODO: These two functions sometimes return nil even when
  #   `self.registrees` would indicate otherwise. When
  #   exactly will these two disagree?
  #

  def section
    semester = Semester.current
    @section ||= semester ? semester.sections.all.find { |section| section.roster.include?(id) } : nil
  end

  def waitlist_course
    semester = Semester.current
    @waitlist_course ||= semester ? semester.courses.all.find { |course| course.waitlist.include?(id) } : nil
  end

  ### methods ###
  def name
    [self.first_name, self.last_name].join " "
  end

  def name=(val)
    parts = val.split " "
    self.first_name = parts.first
    self.last_name  = parts.last
  end

  def sorting_name
    [self.first_name, self.last_name].join " "
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

    !semester.ballots.where(student_id: id).first.nil?
  end

  def enrolled?
    !section.nil?
  end

  def ready_to_register?
    self.level != "unspecified" || self.grade <= 5
  end

  # returns false if section is nil
  def attendance_count(semester=Semester.current)
    self
    .registree
    .section
    .events
    .map(&:rollcall)
    .compact
    .count do |rc|
      rc.present_ish?(self.id)
    end rescue false
  end

  protected
  ### callbacks ###
  def maybe_clear_ballot
    if self.school_grade_changed? || self.level_changed?
      self.registree.destroy if self.registree && self.registree.semester.current?
      self.ballot.destroy if self.ballot && self.ballot.semester.current?
    end
  end
end
