require 'rails_helper'

RSpec.describe Course, type: :model do
  fixtures :semesters
  fixtures :courses
  fixtures :event_groups

  it 'should reject a course without a valid semester' do
    course = Course.new(
      name: "test_course",
      grade: :A)
  end

  it 'should reject a course without a valid grade' do
    [:not_valid, 10, "not valid"].each do |grade|
      expect do
        course = Course.new(
          semester: Semester.first,
          name: "test_course",
          grade: grade)
      end.to raise_error(ArgumentError)
    end

    course = Course.new(
      semester: Semester.first,
      name: "test_course")

    expect(course.save).to eq(false)
  end

  it 'should accept a course with a valid semester and grade' do
    course = Course.new(
      semester: Semester.first,
      name: "test_course",
      grade: :A)

    expect(course.save).to eq(true)
  end
end
