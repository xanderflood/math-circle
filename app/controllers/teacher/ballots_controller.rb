class Teacher::BallotsController < ApplicationController
  before_action :set_ballot,  only: [:edit, :update, :destroy]
  before_action :set_student, only: [:edit, :new]

  rescue_from Ballot::NoCoursesError, with: :no_courses
  rescue_from Ballot::NoLevelError,   with: :no_level

  # GET /ballots/new
  def new
    if @ballot
      redirect_to edit_teacher_student_ballot_path(@student)
    end

    @ballot = Ballot.new(semester: Semester.current, student_id: @student.id)
  end

  # GET /ballots/1/edit
  def edit
  end

  # POST /ballots
  def create
    @ballot = Ballot.new(ballot_params)

    if @ballot.save
      redirect_to teacher_students_path, notice: 'Ballot was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /ballots/1
  def update
    if @ballot.update(ballot_params)
      redirect_to teacher_students_path, notice: 'Ballot was successfully updated.'
    else
      render :new
    end
  end

  # DELETE /ballots/1
  def destroy
    @ballot.destroy
    redirect_to teacher_students_path, notice: 'Ballot was successfully removed.'
  end

  private
    def set_ballot
      @ballot = Ballot.where(student_id: student_id, semester: Semester.current).limit(1).first
    end

    def set_student
      @student = Student.find(student_id)
    end

    def student_id
      params[:student_id] || params[:id]
    end

    # Only allow a trusted parameter "white list" through.
    def ballot_params
      params.fetch(:ballot, {}).permit(:semester_id, :student_id, :course_id, preferences_hash: (1..Ballot::MAX_PREFERENCES).map(&:to_s))
    end

    def no_courses
      redirect_to :back, notice: 'No courses are currently scheduled for this Math-Circle level.'
    end

    def no_level
      redirect_to :back, notice: 'You must specify a Math-Circle level for this student before registering.'
    end
end
