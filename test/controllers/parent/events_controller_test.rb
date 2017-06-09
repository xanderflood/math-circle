require 'test_helper'

class Parent::EventsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get parent_events_index_url
    assert_response :success
  end

  test "should get show" do
    get parent_events_show_url
    assert_response :success
  end

end
