class Teacher::PrioritiesController < Teacher::BaseController
  before_action :set_threshold
  before_action :set_last_semester

  DEFAULT_THRESHOLD = 4

  def manage
  end

  def reset
    unless @threshold = ensure_int(@threshold)
      flash[:alert] = "Please choose a threshold that is an integer."
      render :manage
      return
    end

    table = Rollcall.attendance_table(@last_semester)

    Student.where("id NOT IN (?)", table.keys)
    .update_all(priority: false)

    table.each do |id, att|
      begin
        Student.find(id).update!(priority: (att >= @threshold))
      rescue ActiveRecord::RecordNotFound => e; end

      # some student's listed in last semester's attendance rolls may have been deleted - that's totally acceptable
    end

    redirect_to teacher_home_path, notice: "Student priorities have been reset."
  end

  private
  def set_threshold
    @threshold = params[:threshold] || DEFAULT_THRESHOLD
  end

  def set_last_semester
    @last_semester = Semester.limit(2).order(start: :desc)[1]

    unless @last_semester
      flash[:alert] = "There is only one semester. In order to reset student priorities, you need to have a past semester."
      render :manage
    end
  end

  def ensure_int str
    Integer(str) rescue false
  end
end
