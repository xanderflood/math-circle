class Parent::BallotsController < ApplicationController
  before_action :set_student
  before_action :set_semester, only: [:new, :create, :update]
  before_action :set_ballot,   only: [:show, :update, :destroy]

  # GET /ballots/new
  def new
    @ballot = Ballot.where(student: @student, semester: @semester).first

    if @ballot
      @sections = @ballot.course.sections
      @options  = [["Select Section", nil]] + @sections.map.with_index{ |s, i| [s.description, s.id] }
    else
      @ballot ||= @student.ballots.where
    end

    @preferences = @ballot.ordered_preferences
    binding.pry
  end

  # POST /ballots
  def create
    @ballot = @student.ballots.new(ballot_params)

    if @ballot.save
      redirect_to :back, notice: 'Ballot was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /ballots/1
  def update
    if @ballot.update(ballot_params)
      redirect_to :back, notice: 'Ballot was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /ballots/1
  def destroy
    @ballot.destroy
    redirect_to parent_ballots_url, notice: 'Ballot was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_ballot
      @ballot = Ballot.find(params[:id])
    end

    def set_student
      @student = Student.find(params[:student_id])
    end

    def set_semester
      @semester = Semester.find(params[:semester_id])
    end

    # Only allow a trusted parameter "white list" through.
    def ballot_params
      params.require(:ballot).permit(:student_id, :semester_id, :course_id)
    end
end
