class Ballot < ApplicationRecord
  # makes form_for work with a singleton resource
  model_name.instance_variable_set(:@route_key, 'ballot')

  belongs_to :student
  belongs_to :course
  belongs_to :semester

  serialize :preferences, Array

  self::MAX_PREFERENCES = 10

  validates :student, uniqueness: { scope: :semester, message: "already has a ballot for this semester. To view it, go to your students list, and select \"register\" beside this student's name." }
  validate :non_empty
  validate :unique_sections
  validate :course_in_semester
  validate :sections_in_course
  validate :student_waived, if: :new_record?

  after_initialize :require_level, if: :new_record?
  after_initialize :set_course,    if: :new_record?

  class NoCoursesError < StandardError; end
  class NoLevelError < StandardError; end

  def require_level
    raise NoLevelError if self.student.level == 'unspecified'
  end

  def set_course
    self.course ||= self.courses.first
    raise NoCoursesError if self.course.nil?
  end

  def courses
    @courses ||= Semester.current_courses(self.student.level)
  end

  def padded_size
    # TODO: if I can port this to JavaScript, I can use it
    # [self.course.sections.count, MAX_PREFERENCES].min
    self.course.sections.count
  end

  # for translating the form data into the database format
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

  def registree
    Registree.find_by(student: self.student,
      semester: self.semester, course: self.course)
  end

  def registree_or_new
    registree || Registree.new(student: self.student,
      semester: self.semester, course: self.course)
  end

  protected
  
  # validations
  def student_waived
    errors.add(:base, "You can not register until your waiver has been processed.") if self.student.waiver_confirmed?
  end

  def non_empty
    errors.add(:ballot, "must have at least one selection.") unless self.preferences.count > 0
  end

  def unique_sections
    errors.add(:sections, "must not be repeated.") unless self.preferences.count == self.preferences.uniq.count
  end

  def course_in_semester
    binding.pry unless self.course.semester == self.semester
    errors.add(:course, "is not from the current semester.") unless self.course.semester == self.semester
  end

  def sections_in_course
    unless self.preferences.all? { |s| EventGroup.find(s).course == course }
      errors.add(:preferences, "must all be sections of the selected course.")
    end
  rescue => e
    errors.add(:preferences, "must all be sections of the selected course.")
  end
end
