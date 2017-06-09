require 'test_helper'

class Teacher::EventsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @teacher_event = teacher_events(:one)
  end

  test "should get index" do
    get teacher_events_url
    assert_response :success
  end

  test "should get new" do
    get new_teacher_event_url
    assert_response :success
  end

  test "should create teacher_event" do
    assert_difference('Teacher::Event.count') do
      post teacher_events_url, params: { teacher_event: { when: @teacher_event.when } }
    end

    assert_redirected_to teacher_event_url(Teacher::Event.last)
  end

  test "should show teacher_event" do
    get teacher_event_url(@teacher_event)
    assert_response :success
  end

  test "should get edit" do
    get edit_teacher_event_url(@teacher_event)
    assert_response :success
  end

  test "should update teacher_event" do
    patch teacher_event_url(@teacher_event), params: { teacher_event: { when: @teacher_event.when } }
    assert_redirected_to teacher_event_url(@teacher_event)
  end

  test "should destroy teacher_event" do
    assert_difference('Teacher::Event.count', -1) do
      delete teacher_event_url(@teacher_event)
    end

    assert_redirected_to teacher_events_url
  end
end
