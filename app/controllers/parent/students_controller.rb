class Parent::StudentsController < ApplicationController
  before_action :set_parent_student, only: [:show, :edit, :update, :destroy]

  # GET /parent/students
  # GET /parent/students.json
  def index
    @parent_students = Parent::Student.all
  end

  # GET /parent/students/1
  # GET /parent/students/1.json
  def show
  end

  # GET /parent/students/new
  def new
    @parent_student = Parent::Student.new
  end

  # GET /parent/students/1/edit
  def edit
  end

  # POST /parent/students
  # POST /parent/students.json
  def create
    @parent_student = Parent::Student.new(parent_student_params)

    respond_to do |format|
      if @parent_student.save
        format.html { redirect_to @parent_student, notice: 'Student was successfully created.' }
        format.json { render :show, status: :created, location: @parent_student }
      else
        format.html { render :new }
        format.json { render json: @parent_student.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /parent/students/1
  # PATCH/PUT /parent/students/1.json
  def update
    respond_to do |format|
      if @parent_student.update(parent_student_params)
        format.html { redirect_to @parent_student, notice: 'Student was successfully updated.' }
        format.json { render :show, status: :ok, location: @parent_student }
      else
        format.html { render :edit }
        format.json { render json: @parent_student.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /parent/students/1
  # DELETE /parent/students/1.json
  def destroy
    @parent_student.destroy
    respond_to do |format|
      format.html { redirect_to parent_students_url, notice: 'Student was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_parent_student
      @parent_student = Parent::Student.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def parent_student_params
      params.fetch(:parent_student, {})
    end
end
