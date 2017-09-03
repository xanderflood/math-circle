class Teacher::RegistreesController < Teacher::BaseController
  before_action :set_student
  before_action :set_registree, only: [:show, :edit, :update, :destroy]

  def new
    @registree = Registree.new(student: @student, semester: @semester)
  end

  def edit
  end

  def create
    @registree = Registree.new(registree_params)

    if @registree.save
      redirect_to teacher_students_path, notice: 'Registree was successfully created.'
    else
      render :new
    end
  end

  def update
    if @registree.update(registree_params)
      redirect_to teacher_students_path, notice: 'Registree was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @registree.destroy
    redirect_to teacher_students_path, notice: 'Registree was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_registree
      @registree = Registree.find_by(student_id: student_id, semester: Semester.current)
    end

    def set_student
      @student = Student.find(student_id)
    end

    def student_id
      @student_id ||= params[:student_id] || params[:id]
    end

    # Only allow a trusted parameter "white list" through.
    def registree_params
      params.require(:registree).permit(:student_id, :semester_id, :course_id, :section_id, :student_id, preferences_hash: (1..Ballot::MAX_PREFERENCES).map(&:to_s))
    end
end
