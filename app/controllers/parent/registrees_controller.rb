class Parent::RegistreesController < RegistreesController
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
      redirect_to parent_students_path, notice: 'Registree was successfully created.'
    else
      render :new
    end
  end

  def update
    if @registree.update(registree_params)
      redirect_to parent_students_path, notice: 'Registree was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @registree.destroy
    redirect_to parent_students_path, notice: 'Registree was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_registree
      @registree = @student.registree
    end

    def set_student
      @student = Student.find(student_id)
    end

    def student_id
      @student_id ||= params[:student_id] || params[:id]
    end

    # Only allow a trusted parameter "white list" through.
    def registree_params
      params.require(:registree).permit(:student_id, :course_id, :section_id, :student_id, :preferences)
    end
end
