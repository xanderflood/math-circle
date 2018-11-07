class Level < ApplicationRecord
  default_scope { order(:position) }
  scope :active, -> { where(active: true) }

  has_many :courses
  has_many :students

  validates :position, numericality: {
    only_integer: true,
    greater_than_or_equal_to: 1
  }, if: :unrestricted?
  validates :min_grade, numericality: {
    only_integer: true,
    greater_than_or_equal_to: 1,
    less_than_or_equal_to: 12
  }, if: :unrestricted?
  validates :max_grade, numericality: {
    only_integer: true,
    greater_than_or_equal_to: 1,
    less_than_or_equal_to: 12
  }, if: :unrestricted?
  validate :check_grades

  def permitted? student
    if (self.min_grade > student.school_grade) || (self.max_grade < student.school_grade)
      return false
    end

    return true
  end

  def unrestricted?; !self.restricted; end

  def check_grades
    if !self.restricted && (self.max_grade < self.min_grade)
      errors.add(:base, "Maximum grade is less than minimum grade.")
    end
  end

  def to_s
    name
  end

  def self.get_name(level)
    return "unspecified" unless level
    return level.name
  end
end
