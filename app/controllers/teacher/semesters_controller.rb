class Teacher::SemestersController < Teacher::BaseController
  before_action :set_semester, except: [:new, :create, :index]

  def lottery
    begin
      @lottery = Lottery.new(semester: @semester)
      @lottery.run_lottery
    rescue => e
      lottery_failed!(e)
      return
    end

    unless @lottery.save
      lottery_failed!
      return
    end

    # otherwise, render the lottery view
  end

  def commit_lottery
    @lottery = Lottery.find(params[:lottery_id])

    case @lottery.commit
    when :some_errors
      redirect_to teacher_semester_path(@semester), notice: "Some records could not be saved properly. Information on this error has been logged."
    when true
      redirect_to teacher_semester_path(@semester), notice: "Lottery results successfully saved!"
    when false
      flash.now[:alert] = "Failed to save lottery results, please try again."
      render :lottery
    end
  end

  # GET /teacher/semesters
  # GET /teacher/semesters.json
  def index
    @semesters = Semester.all
  end

  # GET /teacher/semesters/new
  def new
    @semester = Semester.new(current: true)
  end

  def show
  end

  # GET /teacher/semesters/1/edit
  def edit
  end

  # POST /teacher/semesters
  # POST /teacher/semesters.json
  def create
    @semester = Semester.new(semester_params)

    respond_to do |format|
      if @semester.save
        format.html { redirect_to teacher_semesters_path, alert: 'Semester was successfully created.' }
        format.json { render :show, status: :created, location: @semester }
      else
        format.html { render :new }
        format.json { render json: @semester.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /teacher/semesters/1
  # PATCH/PUT /teacher/semesters/1.json
  def update
    respond_to do |format|
      if @semester.update(semester_params)
        format.html { redirect_to teacher_semesters_path, notice: 'Semester was successfully updated.' }
        format.json { render :show, status: :ok, location: @semester }
      else
        format.html { render :edit }
        format.json { render json: @semester.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /teacher/semesters/1
  # DELETE /teacher/semesters/1.json
  def destroy
    @semester.destroy
    respond_to do |format|
      format.html { redirect_to teacher_semesters_url, error: 'Semester was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    def lottery_failed!(e=nil)
      LotterError.save!(e)

      redirect_to :back, notice: "We're sorry, something went wrong and we were unable to complete the lottery."
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_semester
      @semester = Semester.find(params[:semester_id] || params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def semester_params
      params.fetch(:semester, {}).permit(:name, :start, :end, :current)
    end
end
