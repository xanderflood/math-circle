require 'test_helper'

class Teacher::EventGroup::EventsControllerTest < ActionDispatch::IntegrationTest
  test "should get edit" do
    get teacher_event_group_events_edit_url
    assert_response :success
  end

  test "should get update" do
    get teacher_event_group_events_update_url
    assert_response :success
  end

  test "should get destroy" do
    get teacher_event_group_events_destroy_url
    assert_response :success
  end

end
