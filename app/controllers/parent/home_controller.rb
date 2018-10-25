class Parent::HomeController < Parent::BaseController
  def index
    if current_parent.profile.nil?
      redirect_to parent_profile_path
    end
  end

  def catalog
    @semester = Semester.current
    if @semester
      @courses = Semester.current.courses
    else
      redirect_to :back, notice: "There is no semester currently underway."
    end
  end

  def schedule
    @events = current_parent
              .students
              .map(&:registree).compact
              .map(&:section).compact
              .map(&:events).inject([], :+)
  end

  def levels
    @levels = Level.active
  end
end
