module LevelHelper
  def level_restriction_text level
    return "" unless level

    if level.restricted
      return "With teacher permission only."
    else
      return "Grade #{level.min_grade} to <#{level.max_grade}"
    end
  end
end
