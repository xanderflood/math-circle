require 'test_helper'

class Parent::BallotsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @ballot = ballots(:one)
  end

  test "should get index" do
    get ballots_url
    assert_response :success
  end

  test "should get new" do
    get new_ballot_url
    assert_response :success
  end

  test "should create ballot" do
    assert_difference('Ballot.count') do
      post ballots_url, params: { ballot: {  } }
    end

    assert_redirected_to ballot_url(Ballot.last)
  end

  test "should show ballot" do
    get ballot_url(@ballot)
    assert_response :success
  end

  test "should get edit" do
    get edit_ballot_url(@ballot)
    assert_response :success
  end

  test "should update ballot" do
    patch ballot_url(@ballot), params: { ballot: {  } }
    assert_redirected_to ballot_url(@ballot)
  end

  test "should destroy ballot" do
    assert_difference('Ballot.count', -1) do
      delete ballot_url(@ballot)
    end

    assert_redirected_to ballots_url
  end
end
