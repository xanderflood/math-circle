class Teacher::RollcallsController < ApplicationController
  before_action :set_rollcall, only: [:show, :edit, :update, :destroy]

  # GET /rollcalls
  def index
    @rollcalls = Rollcall.all
  end

  # GET /rollcalls/1
  def show
  end

  # GET /rollcalls/new
  def new
    @rollcall = Rollcall.new(event_id: params[:event_id])
  end

  # GET /rollcalls/1/edit
  def edit
  end

  # POST /rollcalls
  def create
    @rollcall = Rollcall.new(rollcall_params)

    if @rollcall.save
      redirect_to @rollcall, notice: 'Rollcall was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /rollcalls/1
  def update
    if @rollcall.update(rollcall_params)
      redirect_to @rollcall, notice: 'Rollcall was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /rollcalls/1
  def destroy
    @rollcall.destroy
    redirect_to rollcalls_url, notice: 'Rollcall was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_rollcall
      @rollcall = Rollcall.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def rollcall_params
      params.fetch(:rollcall, {}).permit(:attendance)
    end
end
