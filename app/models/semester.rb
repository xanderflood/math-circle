class Semester < ApplicationRecord
  default_scope { order(created_at: :desc) }
  after_save :only_one_current_semester

  has_many :courses
  has_many :special_events

  validates :name, presence: { allow_blank: false, message: "must be provided." }
  validate :end_after_start

  enum state: [ :prereg, :reg, :late_reg, :archived ]
  STATE_DESCRIPTION = [
    "hidden from users",
    "open for registration",
    "open for late registration",
    "closed",
    "archived"
  ]

  def self.current
    self.where(current: true).limit(1).first
  end

  def self.current_courses(grade=nil)
    courses = Semester.current.courses
    courses = courses.where(grade: grade) if grade

    courses
  end

  def state_description
    Semester::STATE_DESCRIPTION[state.to_i]
  end

  def compute_lottery
    courses.each do |course|
      # gather the lists and limits
      ballots = Ballot.where(semester: Semester.current, course: course).all.sort_by do |ballot|
        [ballot.student.priority, rand]
      end

      students           = ballot.map(&:student).sort_by(&:priority)
      capacities         = Hash[course.sections.map{ |section| [section.id, section.capacity] }]
      ballots_by_student = Hash[ballots.map { |ballot| [ballot.student_id, ballot] }]

      # keep track of enrollments
      enrollees = Hash.new; enrollees.default = []
      waitlist  = Hash.new; enrollees.default = []
      wait_lens = Hash.new; enrollees.default = 0

      enrolled_in_non_preferred_section = []
      waitlisted                        = []

      ballots.each do |ballot|
        in_order = ballot.preferences[ballot.student_id].map { |p,s| {p: p, s: s} }.sort_by(&:p).map(&:s)
        first_choice = in_order.first

        enrolled = false
        until in_order.empty? do
          section_id = in_order.shift

          next if capacity[section_id] == 0

          capacity[section_id]  -= 1
          enrollees[section_id] << student_id
          enrolled               = true
          break
        end

        next unless enrolled

        unless ballot.exclusive || in_order.empty?
          # TODO: we wanat to do this even if in_order is empty, using the *other* sections 
          section_id = in_order.select{ |s| capacities[s] > 0 }.sample

          if section_id
            capacity[section_id]  -= 1
            enrollees[section_id] << student_id
            enrolled               = true
            break
          end
        end

]        if !enrolled
          # TODO: waitlist
          first_choice









          
        end
      end
    end
  end

  protected
  def only_one_current_semester
    Semester.where(current: true).where('id != ?', id).update_all(current: false) if current
  end

  def end_after_start
    errors.add(:end, 'must be later than the start date.') if self.end <= self.start
  end
end
