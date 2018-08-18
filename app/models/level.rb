class Level < ApplicationRecord
  default_scope { where(active: true) }
  scope :all_levels, -> { unscope(:active) }

  def permitted? student
    if self.min_grade && self.min_grade > student.grade
      return false
    end

    if self.max_grade && self.max_grade < student.grade
      return false
    end

    return true
  end
end
