class Parent::HomeController < Parent::BaseController
  def index
  end

  def catalog
    @semester = Semester.current
    if @semester
      @courses = Semester.current.courses
    else
      redirect_to :back, notice: "There is no semester currently underway."
    end
  end
end
