module BallotsControllable
  extend ActiveSupport::Concern

  included do
    class_attribute :role

    before_action :set_student,  only: [:edit, :new]
    before_action :set_semester
    before_action :set_ballot,   only: [:edit, :update, :destroy]
    before_action :set_params,   only: [:create, :update]
    before_action :check_ballot, only:  :new
  end

  def new
    @ballot = Ballot.new(
      semester: Semester.current,
      student_id: @student.id,
    )
  end

  def edit
  end

  def create
    @ballot = Ballot.new(ballot_params)

    if @ballot.save
      redirect_to [self.class.role, :students], notice: 'Ballot was successfully created.'
    else
      render :new
    end
  end

  def update
    if @ballot.update(ballot_params)
      redirect_to [self.class.role, :students], notice: 'Ballot was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @ballot.destroy
    redirect_to [self.class.role, :students], notice: 'Ballot was successfully removed.'
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

    unless @sections_by_course.count > 0
      redirect_to :back, notice: 'No sections are currently scheduled for this Math-Circle level.'
    end
  end

  def set_ballot
    @ballot = @student.ballot
  end

  def student_id
    @student_id ||= params[:student_id] || params[:id]
  end

  def check_ballot
    redirect_to edit_teacher_student_ballot_path(@student) if @ballot
  end

  # Only allow a trusted parameter "white list" through.
  attr_reader :ballot_params
  def set_params
    @ballot_params = params.require(:ballot).permit(:student_id, :semester_id, :course_id, preferences_hash: (1..Ballot::MAX_PREFERENCES))

    @registree_params[:student_id] ||= @student_id
  end
end
