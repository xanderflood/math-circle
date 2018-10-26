class Teacher::SectionsController < Teacher::BaseController
  before_action :set_section, except: [:new, :create, :index]

  include CsvDownloads

  csv_download :attendance,
    object:   :@section,
    filename: ->(section) { section.attendance_file_name },
    header:   ->(section) { section.attendance_headers   },
    data:     ->(section) { section.attendance_rows      }

  # GET /teacher/events/1
  # GET /teacher/events/1.json
  def show
  end

  # GET /teacher/events/new
  def new
    @section = EventGroup.new(course_id: params[:course_id])
  end

  # GET /teacher/events/1/edit
  def edit
  end

  # POST /teacher/events
  # POST /teacher/events.json
  def create
    @section = EventGroup.new(section_params)

    respond_to do |format|
      if @section.save
        format.html { redirect_to teacher_course_path(@section.course), notice: 'Event was successfully created.' }
        format.json { render :show, status: :created, location: @section }
      else
        format.html { render :new }
        format.json { render json: @section.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /teacher/events/1
  # PATCH/PUT /teacher/events/1.json
  def update
    respond_to do |format|
      if @section.update(section_params)
        format.html { redirect_to teacher_section_path(@section), notice: 'Event was successfully updated.' }
        format.json { render :show, status: :ok, location: @section }
      else
        format.html { render :edit }
        format.json { render json: @section.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /teacher/events/1
  # DELETE /teacher/events/1.json
  def destroy
    @section.destroy
    respond_to do |format|
      format.html { redirect_to :back, notice: 'Event was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_section
      @section = EventGroup.find(params[:id] || params[:section_id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def section_params
      params.require(:event_group).permit(:name, :wday, :event_time, :course_id, :capacity)
    end
end
