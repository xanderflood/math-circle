class Parent::StudentsController < Parent::BaseController
  before_action :set_student, only: [:show, :edit, :update, :destroy, :catalog, :schedule]

  # GET /students
  def index
    @students  = current_parent.students.all
    @semesters = Semester.all
  end

  # GET /students/1
  def show
  end

  # GET /students/new
  def new
    @student = Student.new(parent: current_parent)
  end

  # GET /students/1/edit
  def edit
  end

  # POST /students
  def create
    @student = current_parent.students.new(student_params)

    if @student.save
      begin
        RemindersMailer.after_profile(@student.parent).deliver_now!
      rescue => e
        LotteryError.save!(e)
      end

      redirect_to parent_students_path, notice: 'Student was successfully created.'
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
    redirect_to parent_students_url, notice: 'Student was successfully destroyed.'
  end

  def schedule
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_student
      @student = Student.find(params[:id] || params[:student_id])
    end

    # Only allow a trusted parameter "white list" through.
    def student_params
      params.fetch(:student, {}).permit(
        :last_name,
        :first_name,
        :birthdate,
        :email,
        :level_id,
        :accommodations,
        :school,
        :school_grade,
        :highest_math_class,
        :waiver_submitted)
    end
end
