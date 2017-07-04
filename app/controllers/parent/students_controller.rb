class Parent::StudentsController < Parent::BaseController
  before_action :set_student, only: [:show, :edit, :update, :destroy]

  # GET /students
  def index
    @students  = Student.all
    @semesters = Semester.all
  end

  # GET /students/1
  def show
  end

  # GET /students/new
  def new
    @student = Student.new
  end

  # GET /students/1/edit
  def edit
  end

  # POST /students
  def create
    @student = current_parent.students.new(student_params)

    if @student.save
      redirect_to parent_student_path(@student), notice: 'Student was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /students/1
  def update
    if @student.update(student_params)
      redirect_to parent_student_path(@student), notice: 'Student was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /students/1
  def destroy
    @student.destroy
    redirect_to students_url, notice: 'Student was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_student
      @student = Student.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def student_params
      params.fetch(:student, {}).permit(:name, :grade, :accomodations)
    end
end
