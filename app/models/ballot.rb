class Ballot < ApplicationRecord
  belongs_to :student
  belongs_to :course
  belongs_to :semester

  def preference_hash
    JSON.parse(self["preferences"])
  end

  validates :student, uniqueness: { scope: :semester, message: "This student already has a ballot for this semester. To view it, go to your students list, and selct \"register\" beside this student's name." }
  validate :course_in_semester
  validate :contiguous,         on: :update
  validate :unique_sections,    on: :update
  validate :sections_in_course, on: :update

  # validations
  def course_in_semester
    unless course.semester == semester
      errors.add(:course, "is from a different semester")
    end
  end

  def contiguous
    last = 0
    pref_hash = preference_hash
    pref_hash.map{ |k,v| k }.sort.each do |i|
      if i.to_i != last + 1
        errors.add(:preferences, "should not have gaps or repeated values")
      end
      last = i.to_i
    end
  end

  def unique_sections
    sections = preference_hash.values.map{ |p| p["section"].to_i }

    unless sections.count == sections.uniq.count
      errors.add(:sections, "must not be repeated")
    end
  end

  def sections_in_course
    sections = preference_hash.values.map{ |p| p["section"].to_i }

    unless sections.all? { |s| EventGroup.find(s).course == course }
      # binding.pry
      errors.add(:preferences, "must all be sections of the selected course")
    end
  rescue => e
    # binding.pry
    errors.add(:preferences, "must all be sections of the selected course")
  end

  # override the getter and setter to pad it out with nils
  def preferences
    chosen = preference_hash
    needed = course.sections.count - chosen.count

    chosen.merge Hash[(1..needed).to_a.map { |i| [(chosen.count + i).to_s, { "section" => nil }] }]
  end

  def preferences=(prefs)
    if prefs.nil? || prefs.empty?
      self["preferences"] = "{}"
      return
    end

    self["preferences"] = Hash[prefs.select do |i, pref|
      pref["section"].present?
    end].to_json
  end
end
