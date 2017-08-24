class Registree < ApplicationRecord
  # makes form_for work with a singleton resource
  model_name.instance_variable_set(:@route_key, 'registree')

  ### attributes ###
  belongs_to :semester
  belongs_to :student
  belongs_to :course
  belongs_to :section, class_name: "EventGroup"
  serialize :preferences, Array

  ### callbacks ###
  before_save :section_xor_preferences

  validates :student, uniqueness: { scope: :semester, message: "already has a ballot for this semester. To view it, go to your students list, and select \"register\" beside this student's name." }
  validate :preferences_nonempty_and_unique
  validate :course_in_semester

  after_initialize :require_level, :if => :new_record?
  after_initialize :set_semester,  :if => :new_record?
  after_initialize :set_course,    :if => :new_record?
  after_initialize :set_section,   :if => :new_record?

  # methods
  def courses
    @courses ||= Semester.current_courses(self.student.level)
  end

  def sections
    @sections ||= self.course.sections
  end

  # write a concern or a class method to do:
  # preferences :preferences
  def preferences_hash
    self.preferences ||= []
    Hash[(0..padded_size-1).collect do |i|
      [(i+1).to_s, self.preferences[i].to_s]
    end]
  end

  def preferences_hash=(hash)
    self.preferences = hash.to_a.
      reject  { |obj| obj[1].empty? }.
      sort_by { |obj| obj[0].to_i }.
      map     { |obj| obj[1].to_i }
  end

  def correct?
    if section
      return section.roster.include? student.id
    else
      return course.waitlist.include? student.id
    end
  end

  # callbacks
  class NoCoursesError < StandardError; end
  class NoLevelError < StandardError; end

  def require_level
    raise NoLevelError if self.student.level == 'unspecified'
  end

  def set_semester
    self.semester ||= Semester.current
  end

  def set_course
    self.course ||= self.courses.first
    raise NoCoursesError if self.course.nil?
  end

  def set_section
    self.section ||= self.sections.first
  end

  def section_xor_preferences
    self.preferences = [] if self.section
  end

  def preferences_nonempty_and_unique
    if self.section.nil?
      errors.add(:base, "To join the waitlist, you must select your section preferences.") unless self.preferences.count > 0
      errors.add(:base, "Preferences must not be repeated.") unless self.preferences.count == self.preferences.uniq.count
    end
  end

  def course_in_semester
    errors.add(:course, "is not from the current semester.") unless self.course.semester == self.semester
  end
end
