class Teacher::SemestersController < ApplicationController
  before_action :set_teacher_semester, only: [:show, :edit, :update, :destroy]

  # GET /teacher/semesters
  # GET /teacher/semesters.json
  def index
    @teacher_semesters = Teacher::Semester.all
  end

  # GET /teacher/semesters/new
  def new
    @teacher_semester = Teacher::Semester.new
  end

  # GET /teacher/semesters/1/edit
  def edit
  end

  # POST /teacher/semesters
  # POST /teacher/semesters.json
  def create
    @teacher_semester = Teacher::Semester.new(teacher_semester_params)

    respond_to do |format|
      if @teacher_semester.save
        format.html { redirect_to teacher_semesters_path, notice: 'Semester was successfully created.' }
        format.json { render :show, status: :created, location: @teacher_semester }
      else
        format.html { render :new }
        format.json { render json: @teacher_semester.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /teacher/semesters/1
  # PATCH/PUT /teacher/semesters/1.json
  def update
    respond_to do |format|
      if @teacher_semester.update(teacher_semester_params)
        format.html { redirect_to teacher_semesters_path, notice: 'Semester was successfully updated.' }
        format.json { render :show, status: :ok, location: @teacher_semester }
      else
        format.html { render :edit }
        format.json { render json: @teacher_semester.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /teacher/semesters/1
  # DELETE /teacher/semesters/1.json
  def destroy
    @teacher_semester.destroy
    respond_to do |format|
      format.html { redirect_to teacher_semesters_url, notice: 'Semester was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_teacher_semester
      @teacher_semester = Teacher::Semester.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def teacher_semester_params
      binding.pry
      params.fetch(:semester, {}).permit(:name, :start, :end)
    end
end
