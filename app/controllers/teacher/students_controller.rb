class Teacher::StudentsController < Teacher::BaseController
  before_action :set_parent, only: [:create]
  before_action :set_student, only: [:show, :edit, :update, :destroy]

  include Searchable
  search :students do |params, students|
    if params[:no_waiver_only]
      students = students.reject(&:waiver_confirmed)
    end
    if params[:accomodations_only]
      students = students.select{ |s| s.accommodations.present? }
    end
    if params[:current_only]
      students = students.select{ |s| s.ballot || s.registree }
    end

    students
  end

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
      begin
        RemindersMailer.after_profile(@student.parent).deliver_now!
      rescue => e
        LotteryError.save!(e)
      end

      redirect_to teacher_student_path(@student), notice: 'Student was successfully created.'
    else
      render :new
    end
  end

  def destroy
    @student.destroy
    redirect_to teacher_students_url, notice: 'Student was successfully destroyed.'
  end

  def name
    student = Student.find_by_id(params[:id])
    if student
      render :ok, json: { id: student.id, name: student.name }
    else
      render json: {}, status: :not_found
    end
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
        :level_id,
        :accommodations,
        :school,
        :school_grade,
        :highest_math_class,
        :priority,
        :waiver_confirmed)
    end
end
