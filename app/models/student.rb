class Student < ApplicationRecord
  belongs_to :parent
  has_many :ballots

  enum grade: GradesHelper::GRADES
  DISPLAY_GRADES = self.grades.reject{ |k,v| k == "D" }.keys.to_a

  validate :permissions_are_irrevocable
  validates_format_of :email, with: EmailHelper::OPTIONAL_EMAIL
  validates :birthdate, presence: true
  validates :school_grade, numericality: {
    only_integer: true,
    greater_than_or_equal_to: 1,
    less_than_or_equal_to: 12
  }

  def permissions_are_irrevocable
    [:waiver, :photo_permission].each do |p|
      errors.add(p, "cannot be revoked.") if self.send(:"#{p}_changed?") && !self.send(p)
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
    Ballot.where(student: self, semester: Semester.current).first
  end
end
