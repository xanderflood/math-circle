module RegistreesControllable
  extend ActiveSupport::Concern

  included do
    class_attribute :role

    before_action :set_student
    before_action :set_semester
    before_action :set_registree, only: [:show, :edit, :update, :destroy]
    before_action :set_params, only: [:create, :update]
  end

  def new
    @registree = Registree.new(
      student: @student,
      semester: @semester)

    @registree.course ||= @registree.courses.first
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

      unless @student
        redirect_to :back, notice: 'You must specify a Math-Circle level for this student before registering.'
      end
    end

    def set_semester
      @semester = Semester.current

      courses_by_section = @semester
                           .courses
                           .where(level: @student.level)
                           .joins(:sections)

      unless courses_by_section.count > 0
        redirect_to :back, notice: 'No sections are currently scheduled for this Math-Circle level.'
      end
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_registree
      @registree = @student.registree
    end

    def student_id
      @student_id ||= params[:student_id] || params[:id]
    end

    # Only allow a trusted parameter "white list" through.
    attr_reader :registree_params
    def set_params
      @registree_params = params.require(:registree).permit(:student_id, :semester_id, :course_id, :section_id, preferences_hash: (1..Ballot::MAX_PREFERENCES).map(&:to_s))

      @registree_params[:section_id] ||= nil
      @registree_params[:student_id] ||= @student_id
    end
end