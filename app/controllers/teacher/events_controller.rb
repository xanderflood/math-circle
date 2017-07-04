class Teacher::EventsController < Teacher::BaseController
  before_action :set_event,       only: [ :edit, :update, :destroy ]
  before_action :set_event_group, only: [ :new,  :create, :index   ]
  
  def new
    @event = Event.new(event_group: @event_group)
  end

  def create
    @event = Event.new(event_params.merge(event_group: @event_group))
    respond_to do |format|
      if @event.save
        format.html { redirect_to teacher_event_groups_path, notice: 'Event was successfully created.' }
        format.json { render :show, status: :created, location: @teacher_event }
      else
        format.html { render :new }
        format.json { render json: @teacher_event.errors, status: :unprocessable_entity }
      end
    end
  end

  def index
    @events = @event_group.events
  end

  def edit
  end

  def update
    respond_to do |format|
      if @event.update(event_params)
        format.html { redirect_to teacher_event_groups_path, notice: 'Event was successfully updated.' }
      else
        format.html { render :edit }
      end
    end
  end

  def destroy
    @event.destroy
    respond_to do |format|
      format.html { redirect_to :back, notice: 'Event was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
  def set_event
    @event = Event.find(params[:id])
  end
  def set_event_group
    @event_group = EventGroup.find(params[:event_group_id])
  end
  def event_params
    params.require(:event).permit(:name, :when, :time)
  end
end
