class Teacher::EventsController < ApplicationController
  before_action :set_event, except: [:new, :create, :index]
  before_action :set_rollcall, only: [:rollcall, :create_rollcall, :update_rollcall]

  def rollcall
  end

  def create_rollcall
    @rollcall.attendance = rollcall_params[:attendance]

    if @rollcall.save
      redirect_to teacher_section_path(@rollcall.event.section), notice: "Attendance record saved."
    else
      flash[:alert] = "Attendance record could not be saved, please try again."
      render :rollcall
    end
  end

  def update_rollcall
    if @rollcall.update(rollcall_params)
      redirect_to teacher_section_path(@rollcall.event.section), notice: "Attendance record saved."
    else
      flash[:alert] = "Attendance record could not be saved, please try again."
      render :rollcall
    end
  end

  # GET /events/1
  def show
  end

  # GET /events/new
  def new
    @event = Event.new(section_id: params[:section_id])
  end

  # GET /events/1/edit
  def edit
  end

  # POST /events
  def create
    @event = Event.new(event_params)

    if @event.save
      redirect_to teacher_section_path(@event.section), notice: 'Event was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /events/1
  def update
    if @event.update(event_params)
      redirect_to teacher_event_path(@event), notice: 'Event was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /events/1
  def destroy
    @event.destroy
    redirect_to :back, notice: 'Event was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_event
      @event = ::Event.find(params[:id] || params[:event_id])
    end

    # Only allow a trusted parameter "white list" through.
    def event_params
      params.require(:event).permit(:name, :when, :time, :section_id)
    end

    def rollcall_params
      params.require(:rollcall).permit(:attendance)
    end

    def set_rollcall
      @rollcall = @event.rollcall_or_new
    end
end
