class Semester < ApplicationRecord
  default_scope { order(start: :desc) }
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
    Semester::STATE_DESCRIPTION[Semester.states[state.to_i]]
  end

  def compute_lottery
    courses.each do |course|
      # gather the lists and limits
      @sections = Hash[course.sections.map { |s| [s.id, s] }]

      # TODO: make sure this sorts in the right direction
      ballots = course.ballots.all.sort_by do |ballot|
        [-ballot.student.priority, rand]
      end

      # binding.pry
      ballots.each do |ballot|
        lottery_for_student(ballot)
      end
    end
  end

  protected
    def lottery_for_student(ballot)
      in_order     = ballot.preferences.clone
      first_choice = in_order.first

      all_section_ids      = ballot.course.sections.map &:id
      unwanted_section_ids = all_section_ids - in_order

      enrolled = false
      until in_order.empty? do
        section_id = in_order.shift

        # returns true if the section was already full
        # this is nexting the inner loop :\
        return if @sections[section_id].add_student(ballot.student, :skip)

        enrolled = true
        break
      end

      return if enrolled

      # if there are no other sections to add them to
      # OR if they request not to be added to any other sections, then
      # just add them to the waitlist of their first choice
      available         = unwanted_section_ids.select { |i| !@sections[i].full? }
      @no_sections_left = available.empty? # TODO: RESET this and USE IT
      if ballot.exclusive? || @no_sections_left
        # TODO: figure out how to explain the process to parents
        #     in their notificaion emails
        @sections[first_choice].add_student(ballot.student)
        return
      end

      # for non-exclusive ballots, add to a random available section
      @sections[available.sample].add_student(ballot.student)
    end

    def only_one_current_semester
      Semester.where(current: true).where('id != ?', id).update_all(current: false) if current
    end

    def end_after_start
      errors.add(:end, 'must be later than the start date.') if self.end <= self.start
    end
end
