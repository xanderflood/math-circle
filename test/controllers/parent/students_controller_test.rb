require 'test_helper'

class Parent::StudentsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @parent_student = parent_students(:one)
  end

  test "should get index" do
    get parent_students_url
    assert_response :success
  end

  test "should get new" do
    get new_parent_student_url
    assert_response :success
  end

  test "should create parent_student" do
    assert_difference('Parent::Student.count') do
      post parent_students_url, params: { parent_student: {  } }
    end

    assert_redirected_to parent_student_url(Parent::Student.last)
  end

  test "should show parent_student" do
    get parent_student_url(@parent_student)
    assert_response :success
  end

  test "should get edit" do
    get edit_parent_student_url(@parent_student)
    assert_response :success
  end

  test "should update parent_student" do
    patch parent_student_url(@parent_student), params: { parent_student: {  } }
    assert_redirected_to parent_student_url(@parent_student)
  end

  test "should destroy parent_student" do
    assert_difference('Parent::Student.count', -1) do
      delete parent_student_url(@parent_student)
    end

    assert_redirected_to parent_students_url
  end
end
