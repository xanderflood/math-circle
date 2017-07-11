class Ballot < ApplicationRecord
  belongs_to :student
  belongs_to :course
  belongs_to :semester

  serialize :preferences, JSON

  def preference_hash
    JSON.parse(self["preferences"])
  end

  self::MAX_PREFERENCES = 10

  validates :student, uniqueness: { scope: :semester, message: "This student already has a ballot for this semester. To view it, go to your students list, and selct \"register\" beside this student's name." }
  validate :course_in_semester
  validate :semester_is_current
  validate :contiguous
  validate :unique_sections
  validate :sections_in_course
  validate :non_empty
  validate :peferences_format

  protected
  
  # validations
  def peferences_format
    # TODO: carefully validate the format of the object
  end

  def non_empty
    errors.add("You must select at least onesection.") unless preferences.values.compact.count > 0
  end

  def course_in_semester
    errors.add(:course, "is not from the current semester.") unless course.semester == semester
  end

  def semester_is_current
    errors.add(:semester, "is not current.") unless semester.current
  end

  def contiguous
    last = 0
    preferences.keys.reject{ |k| preferences[k].empty? }.sort.each do |i|
      if i.to_i != last + 1
        errors.add(:preferences, "should not have gaps or repeated values")
      end
      last = i.to_i
    end
  end

  def unique_sections
    sections = preferences.values.reject(&:'empty?').map(&:to_i)

    unless sections.count == sections.uniq.count
      errors.add(:sections, "must not be repeated")
    end
  end

  def sections_in_course
    sections = preferences.values.reject(&:'empty?').map(&:to_i)

    unless sections.all? { |s| EventGroup.find(s).course == course }
      errors.add(:preferences, "must all be sections of the selected course.")
    end
  rescue => e
    errors.add(:preferences, "must all be sections of the selected course.")
  end
end
