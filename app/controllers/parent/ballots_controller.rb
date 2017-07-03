class Parent::BallotsController < ApplicationController
  before_action :set_student
  before_action :set_semester, only: [:new,  :create, :update]
  before_action :set_ballot,   only: [:show, :update, :destroy]

  # GET /ballots/new
  def new
    @ballot = @student.ballots.where(semester: @semester).first

    if @ballot
      prepare_for_edit
    else
      prepare_for_new
    end
  end

  # POST /ballots
  def create
    @ballot = @student.ballots.new(ballot_params)

    if @ballot.save
      redirect_to new_parent_student_ballot_path(@ballot, student_id: @student.id, semester_id: @semester.id), notice: 'Ballot was successfully created.'
    else
      prepare_for_new
      render :new
    end
  end

  # PATCH/PUT /ballots/1
  def update
    if @ballot.update(ballot_params)
      redirect_to new_parent_student_ballot_path(@ballot, student_id: @student.id, semester_id: @semester.id), notice: 'Ballot was successfully updated.'
    else
      prepare_for_edit
      render :new
    end
  rescue Ballot::PreferenceValidationException
    prepare_for_edit
    flash[:alert] = "Invalid preferences"
    render :new
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
      ret = {semester_id: params["semester_id"]}
      ret.merge(params.require(:ballot).permit(:student_id, :semester_id, :course_id, :preferences))
      ret[:preferences] = params.require(:ballot).require(:preferences).to_unsafe_hash

      ret
    end

    def prepare_for_new
      @ballot = @student.ballots.new(semester: @semester)

      @url = parent_student_ballots_path(@ballot, student_id: @ballot.student.id, semester_id: @ballot.semester.id)
    end

    def prepare_for_edit
      @sections   = @ballot.course.sections
      @options    = [["Select Section", nil]] + @sections.map.with_index{ |s, i| [s.description, s.id] }
      @selections = (1..@sections.count).to_a.map { |i| @ballot.preferences[i]["section"].to_i }

      @url = parent_student_ballot_path(@ballot, student_id: @ballot.student.id, semester_id: @ballot.semester.id)
    end
end
