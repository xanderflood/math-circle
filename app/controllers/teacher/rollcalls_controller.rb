class Teacher::RollcallsController < ApplicationController
  before_action :set_event
  before_action :set_rollcall

  # GET /events/1/rollcall
  def show
  end

  # POST /events/1/rollcall
  def create
    @rollcall.attendance = rollcall_params[:attendance]

    if @rollcall.save
      redirect_to teacher_section_path(@rollcall.event.section), notice: "Attendance record saved."
    else
      flash[:alert] = "Attendance record could not be saved, please try again."
      render :rollcall
    end
  end

  # PATCH/PUT /events/1/rollcall
  def update
    if @rollcall.update(rollcall_params)
      redirect_to teacher_section_path(@rollcall.event.section), notice: "Attendance record saved."
    else
      flash[:alert] = "Attendance record could not be saved, please try again."
      render :rollcall
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_event
      @event = ::Event.find(params[:event_id] || params[:rollcall][:event_id])
    end

    def set_rollcall
      @rollcall = @event.rollcall_or_new
    end

    # Only allow a trusted parameter "white list" through.
    def rollcall_params
      params.fetch(:rollcall, {}).permit(:attendance)
    end
end
