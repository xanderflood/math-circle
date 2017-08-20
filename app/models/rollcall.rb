class Rollcall < ApplicationRecord
  belongs_to :event

  after_initialize :set_date_to_today
  after_initialize :initialize_attendance

  validates :event, uniqueness: { message: "already has a rollcall record." }

  def initialize_attendance
    # if this is being initialized for the first time (so attendance is nil)
    # set everything to present
    if self.attendance == "{}"
      self.attendance = enrollees.map { |e| [e.id, 0] }.to_h.to_json
    end
  end

  def self.for_event_id id
    Rollcall.where(event_id: id).first || Rollcall.new(event_id: id)
  end

  def enrollees
    Student.find(event.section.roster).sort_by(&:sorting_name)
  end

  def student_ids
    attendance_hash.keys
  end

  def attendance_hash
    @attendance_hash ||= JSON.parse(attendance).map do |k,v|
      [k.to_i, (v.nil? ? nil : v.to_i)]
    end.to_h
  end

  def unexpected
    attendance_hash.select { |k,v| v == AttendanceHelper.IDS[:unexpected] }.keys
  end

  def present_ish?(student_id)
    AttendanceHelper.present_ish.map(&:id).include? attendance_hash[student_id].to_i
  end

  private
    def set_date_to_today
      self.date = Date.today
    end
end
