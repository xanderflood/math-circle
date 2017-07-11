class Teacher::SemestersController < Teacher::BaseController
  before_action :set_semester, only: [:show, :edit, :update, :destroy]

  def lottery
  end

  def commit_lottery
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
        format.html { redirect_to teacher_semesters_path, notice: 'Semester was successfully created.' }
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
      format.html { redirect_to teacher_semesters_url, notice: 'Semester was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_semester
      @semester = Semester.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def semester_params
      params.fetch(:semester, {}).permit(:name, :start, :end, :current)
    end
end
