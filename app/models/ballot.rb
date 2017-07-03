class Ballot < ApplicationRecord
  belongs_to :student
  belongs_to :course
  belongs_to :semester
  has_many :ballot_preferences, autosave: true

  validates :student, uniqueness: { scope: :semester }
  validate :course_in_semester
  validate :contiguous

  class PreferenceValidationException < StandardError; end

  # validations
  def course_in_semester
    course.semester == semester
  end

  def contiguous
    last = 0
    ballot_preferences.map(&:preference).sort.each do |i|
      return falst if i != last + 1
      last = i
    end
  end

  # Getter and setter that avoids nils
  def preferences
    needed      = course.sections.count - ballot_preferences.count
    pref_hashes = ballot_preferences.all.sort_by(&:preference).map { |p| [p.preference, { "section" => p.section_id }] }

    Hash[pref_hashes + (1..needed).to_a.map { |i| [p.preference, { "section" => p.section_id }] }]
  end

  def preferences=(prefs)
    b_prefs_to_save = []

    prefs.each do |i, pref|
      bp = ballot_preferences.where(preference: i.to_i).first

      if bp
        bp.section_id = pref["section"].to_i
        binding.pry
        raise PreferenceValidationException unless bp.save # TODO: handle errors
        binding.pry
      else
        ballot_preferences.new(preference: i, section_id: pref["section"].to_i)
        raise PreferenceValidationException unless bp.save # TODO: handle errors
      end
    end

    # pbp = padded_ballot_preferences
    # pbp.each do |ballot_pref|
      # binding.pry
    #   ballot_pref.section_id = prefs[ballot_pref.preference.to_s]["section"].to_i
    # end
    # prefs.each do |i, p|
    #   set_preference(i, p["section"].to_i)
    # end
  end

  def set_preference(i, section_id)
    pref_obj = ballot_preferences.where(preference: i).first

    if pref_obj
      binding.pry
      pref_obj.section_id = section_id
    else
      ballot_preferences.new(
          section_id: section_id,
          preference: i)
    end
  end

  ### ### ###
  def padded_ballot_preferences
    needed = course.sections.count - ballot_preferences.count

    ballot_preferences.all.sort_by(&:preference) + (1..needed).to_a.each do |i|
      ballot_preferences.new(preference: ballot_preferences.count + i - 1, section_id: nil)
    end
  end

  # def preferences=(prefs)
  #   b_prefs_to_save = []
  #   prefs.each do |i, p|
  #     set_preference(i, p["section"])
  #   end
  # end

  # business logic
  # def ordered_preferences
  #   ballot_preferences.all.sort_by(&:preference).map(&:section)
  # end
end
