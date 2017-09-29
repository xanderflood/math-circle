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
      message: " is required."
    }, unless: :waiver_force
  validates :school_grade, numericality: {
      only_integer: true,
      greater_than_or_equal_to: 1,
      less_than_or_equal_to: 12
    }

  ### non-rails associations ###
  def ballot; @ballot ||= Ballot.find_by(student: self, semester: Semester.current); end
  def registree; @registree ||= Registree.find_by(student: self, semester: Semester.current); end

  def section; self.registree.section; end
  def course; self.registree.course; end

  ### methods ###
  def sorting_name; [self.first_name, self.last_name].join(" "); end
  def name; [self.first_name, self.last_name].join(" "); end
  def name=(val)
    parts = val.split " "
    self.first_name = parts.first
    self.last_name  = parts.last
  end

  def ready_to_register?; self.level != "unspecified" || self.grade <= 5;    end
  def registered?; Semester.current && self.ballot    && !self.ballot.nil?;  end
  def waitlisted?; Semester.current && self.registree &&  self.section.nil?; end
  def enrolled?;   Semester.current && self.registree && !self.section.nil?; end

  def waitlist_position(section=nil)
    if self.waitlisted? && section
      section.waitlist.index(self) if section.waitlist.include? self
    elsif self.waitlisted?
      self.course.waitlist.index(self)
    end
  end

  def attendance_count(semester=Semester.current)
    section.events.map(&:rollcall).compact.count { |rc| rc.present_ih?(self.id) }
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

  protected
  ### callbacks ###
  def maybe_clear_ballot
    if self.school_grade_changed? || self.level_changed?
      self.registree.destroy if self.registree && self.registree.semester.current?
      self.ballot.destroy if self.ballot && self.ballot.semester.current?
    end
  end
end
