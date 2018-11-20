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

  after_initialize :set_position, if: :new_record?

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

  # for test building fixtures
  def self.random
    self.where(active: true).offset(rand()*Level.active.count).first
  end

  private
  def set_position
    self.position ||= Level.next_position
  end

  def self.next_position
    self.order(:position).last.position rescue 1
  end
end
