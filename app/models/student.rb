class Student < ApplicationRecord
  has_one :contact_info
  belongs_to :parent
  has_many :ballots

  belongs_to :emergency_contact,   class_name: ContactInfo
  belongs_to :emergency_contact_2, class_name: ContactInfo

  validates_format_of :email, with: EmailHelper::OPTIONAL_EMAIL

  enum grade: GradesHelper::GRADES

  def section
    semester = Semester.current
    @section ||= semester ? semester.sections.all.find { |section| section.roster.include?(id) } : nil
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
