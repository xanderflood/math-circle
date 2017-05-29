require 'test_helper'

class Teacher::SemestersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @teacher_semester = teacher_semesters(:one)
  end

  test "should get index" do
    get teacher_semesters_url
    assert_response :success
  end

  test "should get new" do
    get new_teacher_semester_url
    assert_response :success
  end

  test "should create teacher_semester" do
    assert_difference('Teacher::Semester.count') do
      post teacher_semesters_url, params: { teacher_semester: {  } }
    end

    assert_redirected_to teacher_semester_url(Teacher::Semester.last)
  end

  test "should show teacher_semester" do
    get teacher_semester_url(@teacher_semester)
    assert_response :success
  end

  test "should get edit" do
    get edit_teacher_semester_url(@teacher_semester)
    assert_response :success
  end

  test "should update teacher_semester" do
    patch teacher_semester_url(@teacher_semester), params: { teacher_semester: {  } }
    assert_redirected_to teacher_semester_url(@teacher_semester)
  end

  test "should destroy teacher_semester" do
    assert_difference('Teacher::Semester.count', -1) do
      delete teacher_semester_url(@teacher_semester)
    end

    assert_redirected_to teacher_semesters_url
  end
end
