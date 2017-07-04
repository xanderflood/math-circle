class Teacher::EventGroupsController < Teacher::BaseController
  before_action :set_teacher_event, only: [:show, :edit, :update, :destroy]

  # GET /teacher/events
  # GET /teacher/events.json
  def index
    @event_groups = ::EventGroup.all
  end

  # GET /teacher/events/1
  # GET /teacher/events/1.json
  def show
  end

  # GET /teacher/events/new
  def new
    @event_group = EventGroup.new
  end

  # GET /teacher/events/1/edit
  def edit
  end

  # POST /teacher/events
  # POST /teacher/events.json
  def create
    @event_group = EventGroup.new(teacher_event_params.merge(
      start_date: get_date(params[:event_group], :start_date),
      end_date:   get_date(params[:event_group], :end_date)))

    respond_to do |format|
      if @event_group.save
        format.html { redirect_to teacher_event_groups_path, notice: 'Event was successfully created.' }
        format.json { render :show, status: :created, location: @event_group }
      else
        format.html { render :new }
        format.json { render json: @event_group.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /teacher/events/1
  # PATCH/PUT /teacher/events/1.json
  def update
    respond_to do |format|
      if @event_group.update(teacher_event_params)
        format.html { redirect_to @event_group, notice: 'Event was successfully updated.' }
        format.json { render :show, status: :ok, location: @event_group }
      else
        format.html { render :edit }
        format.json { render json: @event_group.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /teacher/events/1
  # DELETE /teacher/events/1.json
  def destroy
    @event_group.destroy
    respond_to do |format|
      format.html { redirect_to :back, notice: 'Event was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_teacher_event
      @event_group = EventGroup.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def teacher_event_params
      params.require(:event_group).permit(:name, :course_id, :wday, :time)
    end

    def date_keys key, n=3
      (1..n).map { |e| "#{key}(#{e}i)" }
    end

    def get_date hash, key
      DateTime.new *(date_keys(key).map{ |k| hash[k].to_i })
    end

    def list_occurrences schedule_hash, start_date, end_date
      r = IceCube::Rule.from_hash(schedule_hash)
      s = IceCube::Schedule.new
      s.add_recurrence_rule(r)
      s.start_time = start_date

      s.occurrences(end_date)
    end
end
