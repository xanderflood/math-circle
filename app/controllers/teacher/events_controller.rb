class Teacher::EventsController < ApplicationController
  before_action :set_teacher_event, only: [:show, :edit, :update, :destroy]

  # GET /teacher/events
  # GET /teacher/events.json
  def index
    @teacher_events = Teacher::Event.all
  end

  # GET /teacher/events/1
  # GET /teacher/events/1.json
  def show
  end

  # GET /teacher/events/new
  def new
    @teacher_event = Teacher::Event.new
  end

  # GET /teacher/events/1/edit
  def edit
  end

  # POST /teacher/events
  # POST /teacher/events.json
  def create
    @teacher_event = Teacher::Event.new(teacher_event_params)

    respond_to do |format|
      if @teacher_event.save
        format.html { redirect_to @teacher_event, notice: 'Event was successfully created.' }
        format.json { render :show, status: :created, location: @teacher_event }
      else
        format.html { render :new }
        format.json { render json: @teacher_event.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /teacher/events/1
  # PATCH/PUT /teacher/events/1.json
  def update
    respond_to do |format|
      if @teacher_event.update(teacher_event_params)
        format.html { redirect_to @teacher_event, notice: 'Event was successfully updated.' }
        format.json { render :show, status: :ok, location: @teacher_event }
      else
        format.html { render :edit }
        format.json { render json: @teacher_event.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /teacher/events/1
  # DELETE /teacher/events/1.json
  def destroy
    @teacher_event.destroy
    respond_to do |format|
      format.html { redirect_to teacher_events_url, notice: 'Event was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_teacher_event
      @teacher_event = Teacher::Event.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def teacher_event_params
      binding.pry
      params.require(:teacher_event).permit(:when)
    end
end
