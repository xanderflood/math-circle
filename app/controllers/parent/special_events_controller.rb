class Parent::SpecialEventsController < Parent::BaseController
  def index
    @special_events = Semester.current.special_events.all
  end
end
