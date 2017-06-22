class Teacher::EventsController < ApplicationController
  before_action :set_event,       only: [ :edit, :update, :destroy ]
  before_action :set_event_group, only: [ :new,  :create, :index   ]
  
  def new
    @event = Event.new(event_group: @event_group)
  end

  def create
    binding.pry
    redirect_to teacher_event_groups_path
  end

  def index
  end

  def edit
  end

  def update
    binding.pry
    redirect_to teacher_event_groups_path
  end

  def destroy
    binding.pry
  end

  private
  def set_event
    @event = Event.find(params[:id])
  end
  def set_event_group
    @event_group = EventGroup.find(params[:event_group_id])
  end
end
