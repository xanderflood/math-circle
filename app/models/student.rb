class Student < ApplicationRecord
  has_one :contact_info
  belongs_to :parent
  has_many :ballots

  enum grade: GradesHelper::GRADES

  def section
    @section ||= semester.sections.all.find { |section| section.roster.include?(id) }
  end

  def attendance_count(semester=Semester.current)
    section.events.map(&:rollcall).compact.count { |rc| rc.present_ih?(self.id) }
  end

  def ballot
    Ballot.where(student: self, semester: Semester.current).first
  end
end
