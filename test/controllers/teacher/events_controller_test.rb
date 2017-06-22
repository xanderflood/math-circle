require 'test_helper'

class Teacher::EventsControllerTest < ActionDispatch::IntegrationTest
  test "should get edit" do
    get teacher_events_edit_url
    assert_response :success
  end

  test "should get update" do
    get teacher_events_update_url
    assert_response :success
  end

end
