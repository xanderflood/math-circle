class Teacher::Parents::StudentsController < Teacher::BaseController
  before_action :set_parent

  def index
    @students = @parent.students
  end

  def new
    @student = @parent.students.new
  end

  private
    def set_parent
      @parent = Parent.find(params[:parent_id])
    end

    # Only allow a trusted parameter "white list" through.
    def student_params
      params.fetch(:student, {}).permit(
        :waiver_force,
        :last_name,
        :first_name,
        :birthdate,
        :email,
        :level,
        :accommodations,
        :school,
        :school_grade,
        :highest_math_class,
        :priority,
        :waiver_confirmed)
    end
end
