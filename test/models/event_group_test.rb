require 'test_helper'

class EventGroupTest < ActiveSupport::TestCase
  test "creates the right number of sections" do
    for i in 1..10 do
      semester = Semester.new(
        name:  i.to_s,
        start: Date.today,
        end:   Date.today + i.weeks)

      course  = Course.new(
        semseter: semester,
        name:     i.to_s)

      section = EventGroup.new(
        course: course,
        wday: Date.today.wday,
        time: Time.now)
      # force the after_save callback
      section.populate_events
      assert section.events.count == i

      section = EventGroup.new(
        course: course,
        wday: Date.tomorrow.wday,
        time: Time.now)
      # force the after_save callback
      section.populate_events
      assert section.events.count == i - 1

      section = EventGroup.new(
        course: course,
        wday: (Date.today + 2.days).  wday,
        time: Time.now)
      # force the after_save callback
      section.populate_events
      assert section.events.count == i - 1
    end
  end
end
  