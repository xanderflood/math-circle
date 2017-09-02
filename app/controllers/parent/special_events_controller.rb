class Parent::SpecialEventsController < Parent::BaseController
  def index
    @special_events = Semester.current_special_events
  end
end
