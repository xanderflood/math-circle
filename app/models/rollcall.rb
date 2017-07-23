class Rollcall < ApplicationRecord
  belongs_to :event

  after_initialize :set_date_to_today

  validates :event, uniqueness: { message: "This event already has a rollcall record." }

  def self.for_event_id id
    Rollcall.where(event_id: id).first || Rollcall.new(event_id: id)
  end

  def enrollees
    Student.find event.section.roster
  end

  def attendance_hash
    @attendance_hash ||= JSON.parse(attendance).map do |k,v|
      v = v.to_i unless v.nil?
      [k.to_i, (v.nil? ? nil : v.to_i)]
    end.to_h
  end

  # def extras
  # end

  def counts_for?(student_id)
    AttendanceHelper.okay.map(&:id).include? attendance_hash[student_id].to_i
  end

  private
    def set_date_to_today
      self.date = Date.today
    end
end
