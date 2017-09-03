class Teacher::StudentsController < Teacher::BaseController
  before_action :set_parent, only: [:create]
  before_action :set_student, only: [:show, :edit, :update, :destroy]

  def index
    @students = Student.order(:first_name, :last_name).paginate(page: params[:page], per_page: 50)
  end

  def show
  end

  def edit
  end

  def update
    if @student.update(student_params)
      redirect_to teacher_student_path(@student), notice: 'Student was successfully updated.'
    else
      render :edit
    end
  end

  def create
    @student = @parent.students.new(student_params)
    @student.waiver_force = true

    if @student.save
      redirect_to teacher_student_path(@student), notice: 'Student was successfully created.'
    else
      render :new
    end
  end

  def destroy
    @student.destroy
    redirect_to students_url, notice: 'Student was successfully destroyed.'
  end

  def search
    @students = Student.where("first_name ILIKE ?", "%#{params[:search][:first_name]}%")
                       .where("last_name ILIKE ?",  "%#{params[:search][:last_name]}%")
  end

  private
    def set_parent
      @parent = Parent.find(params[:parent_id])
    end

    def set_student
      @student = Student.find(params[:id])
    end

    def student_params
      params.fetch(:student, {}).permit(
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
