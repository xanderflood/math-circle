class Student < ApplicationRecord
  has_one :contact_info
  belongs_to :parent
  has_many :ballots

  enum grade: GradesHelper::GRADES

  def attendance_count(semester=Semester.current)
    section = semester.sections.all.find { |section| section.roster.include?(id) }

    section.events.map(&:rollcall_or_nil).compact.count { |rc| rc.counts_for?(self.id) }
  end

  def ballot
    Ballot.where(student: self, semester: Semester.current).first
  end
end
