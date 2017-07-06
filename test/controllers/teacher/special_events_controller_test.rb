require 'test_helper'

class Teacher::SpecialEventsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @special_event = special_events(:one)
  end

  test "should get index" do
    get special_events_url
    assert_response :success
  end

  test "should get new" do
    get new_special_event_url
    assert_response :success
  end

  test "should create special_event" do
    assert_difference('SpecialEvent.count') do
      post special_events_url, params: { special_event: {  } }
    end

    assert_redirected_to special_event_url(SpecialEvent.last)
  end

  test "should show special_event" do
    get special_event_url(@special_event)
    assert_response :success
  end

  test "should get edit" do
    get edit_special_event_url(@special_event)
    assert_response :success
  end

  test "should update special_event" do
    patch special_event_url(@special_event), params: { special_event: {  } }
    assert_redirected_to special_event_url(@special_event)
  end

  test "should destroy special_event" do
    assert_difference('SpecialEvent.count', -1) do
      delete special_event_url(@special_event)
    end

    assert_redirected_to special_events_url
  end
end
