class Teacher::SpecialEventsController < ApplicationController
  before_action :set_special_event, only: [:show, :edit, :update, :destroy]

  # GET /special_events
  def index
    @special_events = SpecialEvent.all
  end

  # GET /special_events/1
  def show
  end

  # GET /special_events/new
  def new
    @special_event = SpecialEvent.new(semester_id: params[:semester_id])
  end

  # GET /special_events/1/edit
  def edit
  end

  # POST /special_events
  def create
    @special_event = SpecialEvent.new(special_event_params)

    if @special_event.save
      redirect_to teacher_semester_path(@special_event.semester), notice: 'Special event was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /special_events/1
  def update
    if @special_event.update(special_event_params)
      redirect_to teacher_special_event_path(@special_event), notice: 'Special event was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /special_events/1
  def destroy
    @special_event.destroy
    redirect_to teacher_special_events_url, notice: 'Special event was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_special_event
      @special_event = SpecialEvent.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def special_event_params
      params.fetch(:special_event, {}).permit(:name, :capacity, :date, :start, :end, :description, :semester_id)
    end
end
