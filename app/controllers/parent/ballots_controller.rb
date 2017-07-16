class Parent::BallotsController < ApplicationController
  before_action :set_ballot, only: [:show, :edit, :update, :destroy]

  rescue_from Ballot::NoCoursesError, with: :no_courses
  rescue_from Ballot::NoGradeError, with: :no_grade

  # GET /ballots
  # def index
  #   @ballots = Ballot.all()
  # end

  # GET /ballots/1
  # def show
  # end

  # GET /ballots/new
  def new
    begin
      @ballot   = Ballot.where(student_id: params[:student_id]).limit(1).first
      @ballot ||= Ballot.new(semester: Semester.current, student_id: params[:student_id])
    end
  end

  # GET /ballots/1/edit
  def edit
  end

  # POST /ballots
  def create
    @ballot = Ballot.new(ballot_params)

    if @ballot.save
      redirect_to parent_students_path, notice: 'Ballot was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /ballots/1
  def update
    if @ballot.update(ballot_params)
      redirect_to parent_students_path, notice: 'Ballot was successfully updated.'
    else
      render :new
    end
  end

  # DELETE /ballots/1
  def destroy
    @ballot.destroy
    redirect_to parent_students_url, notice: 'Ballot was successfully removed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_ballot
      @ballot = Ballot.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def ballot_params
      params.fetch(:ballot, {}).permit(:semester_id, :student_id, :course_id, :exclusive, preferences_hash: (1..Ballot::MAX_PREFERENCES).map(&:to_s))
    end

    def no_courses
      redirect_to :back, notice: 'No courses are currently scheduled for this grade level.'
    end

    def no_courses
      redirect_to :back, notice: 'You must specify a grade level for this student before registering.'
    end
end
