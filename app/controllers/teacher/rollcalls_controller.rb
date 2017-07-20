class Teacher::RollcallsController < ApplicationController
  before_action :set_event
  before_action :set_rollcall

  # GET /rollcalls/1/edit
  def edit
  end

  # POST /rollcalls
  def create
    @rollcall = Rollcall.new(rollcall_params)

    if @rollcall.save
      redirect_to teacher_rollcall_path(@rollcall), notice: 'Rollcall was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /rollcalls/1
  def update
    if @rollcall.update(rollcall_params)
      redirect_to teacher_rollcall_path(@rollcall), notice: 'Rollcall was successfully updated.'
    else
      render :edit
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_event
      @event = Event.find(params[:id])
    end

    def set_rollcall
      @rollcall = Rollcall.for_event_id(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def rollcall_params
      params.fetch(:rollcall, {}).permit(:attendance)
    end
end
