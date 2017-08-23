class Teacher::StudentsController < ApplicationController
  before_action :set_student, only: [:show, :edit, :update, :destroy]

  # GET /students
  def index
    @students = Student.order(:first_name, :last_name).paginate(page: params[:page], per_page: 50)
  end

  # GET /students/1
  def show
  end

  # GET /students/1/edit
  def edit
  end

  # PATCH/PUT /students/1
  def update
    if @student.update(student_params)
      redirect_to teacher_student_path(@student), notice: 'Student was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /students/1
  def destroy
    @student.destroy
    redirect_to students_url, notice: 'Student was successfully destroyed.'
  end

  def search
    @students = Student.where("first_name ILIKE ?", "%#{params[:search][:first_name]}%")
                       .where("last_name ILIKE ?",  "%#{params[:search][:last_name]}%")
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_student
      @student = Student.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
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
