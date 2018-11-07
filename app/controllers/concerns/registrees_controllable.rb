module RegistreesControllable
  extend ActiveSupport::Concern

  included do
    class_attribute :role

    before_action :set_student
    before_action :set_semester
    before_action :set_registree,   only: [:edit, :update, :destroy, :courses]
    before_action :set_params,      only: [:create, :update]
    before_action :set_course,      only: [:new, :edit, :courses]
    before_action :check_registree, only:  :new
  end

  def courses
    target = params["target"]

    if @registree.present?
      @courses = @registree.courses
      @course_id = @registree.course_id
    else
      @courses = Semester.current_courses(@student.level)
    end

    if @courses.length == 1
      redirect_to [:new, self.class.role, @student, :registree]
    else
      @url_template = polymorphic_path([target, self.class.role, @student, :registree], course_id: "courseID")

      render 'shared/registrees/courses'
    end
  end

  def new
    @registree = Registree.new(
      student: @student,
      semester: @semester,
      course_id: @course_id)

    # TODO: if !@registree.course, then redirect to courses?
    @registree.course_id ||= @registree.courses.first.id
    unless @registree.waitlisted
      @registree.section ||= @registree.sections.reject(&:full?).first
    end
  end

  def edit
  end

  def create
    @registree = Registree.new(registree_params)

    if @registree.save
      redirect_to [self.class.role, :students], notice: 'Registree was successfully created.'
    else
      render :new
    end
  end

  def update
    if @registree.update(registree_params)
      redirect_to [self.class.role, :students], notice: 'Registree was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @registree.destroy
    redirect_to [self.class.role, :students], notice: 'Registree was successfully destroyed.'
  end

  private
    def set_student
      @student = Student.find(student_id)

      if !@student.level_ok?
        redirect_to :back, notice: 'You must specify a Math-Circle level for this student before registering.'
      end
    end

    def set_semester
      @semester = Semester.current
      @courses = @semester.courses.where(level_id: @student.level_id)
      @sections_by_course = @courses.joins(:sections).count

      unless @sections_by_course > 0
        redirect_to :back, notice: 'No sections are currently scheduled for this Math-Circle level.'
      end
    end

    def set_course
      @course_id = params["course_id"]
    end

    def set_registree
      @registree = @student.registree

      if @course_id.present? && @registree.present?
        @registree.course = Course.find(@course_id)
      end
    end

    def student_id
      @student_id ||= params[:student_id] || params[:id]
    end

    def check_registree
      redirect_to edit_teacher_student_registree_path(@student) if @registree
    end

    # Only allow a trusted parameter "white list" through.
    attr_reader :registree_params
    def set_params
      @registree_params = params.require(:registree).permit(
        :student_id,
        :semester_id,
        :course_id,
        :section_id,
        preferences_hash: (1..Ballot::MAX_PREFERENCES).map(&:to_s))

      @registree_params[:section_id] ||= nil
      @registree_params[:student_id] ||= @student_id
    end
end
