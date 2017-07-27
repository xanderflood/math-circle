class Teacher::CoursesController < Teacher::BaseController
  before_action :set_course, only: [:show, :edit, :update, :destroy]

  # GET /courses/1
  def show
  end

  # GET /courses/new
  def new
    @course = Course.new(semester_id: params[:semester_id])
  end

  # GET /courses/1/edit
  def edit
  end

  # POST /courses
  def create
    @course = Course.new(course_params)

    if @course.save
      redirect_to teacher_semester_path(@course.semester), notice: 'Course was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /courses/1
  def update
    if @course.update(course_params)
      redirect_to teacher_course_path(@course), notice: 'Course was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /courses/1
  def destroy
    @course.destroy
    redirect_to teacher_courses_url, notice: 'Course was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_course
      @course = Course.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def course_params
      params.fetch(:course, {}).permit(:name, :grade, :capacity, :semester_id, :overview)
    end
end
