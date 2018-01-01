require 'rails_helper'

RSpec.describe EventGroup, type: :model do
  fixtures :semesters
  fixtures :courses
  fixtures :event_groups

  it 'should reject an event_group without a valid weekday and time' do
    section = Course.first.sections.new(
      wday: :monday,
      capacity: 10)

    expect(section.save).to eq false

    section = Course.first.sections.new(
      time: Time.now,
      capacity: 10)

    expect(section.save).to eq false
  end

  it 'should reject an event_group without a valid course' do
    section = EventGroup.new(
      wday: :monday,
      time: Time.now,
      capacity: 10)

    expect(section.save).to eq false
  end

  it 'should accept an event_group with a course, weekday, and time' do
    course = Course.first
    section = course.sections.create!(
      wday: :monday,
      time: Time.now,
      capacity: 10)

    expect(section.save).to eq true
    expect(section.roster).to eq []
    expect(section.waitlist).to eq []
  end

  it 'should create the appropriate number of events for its semester' do
    # the sunday-to-saturday semester
    section = FactoryGirl.create(:event_group,
      course: courses(:As18), # grabbed from fixtures
      wday: :sunday)
    expect(section.events.count).to eq 16

    section = FactoryGirl.create(:event_group,
      course: courses(:As18), # grabbed from fixtures
      wday: :monday)
    expect(section.events.count).to eq 16

    section = FactoryGirl.create(:event_group,
      course: courses(:As18), # grabbed from fixtures
      wday: :tuesday)
    expect(section.events.count).to eq 16

    # the saturday-to-sunday semester
    section = FactoryGirl.create(:event_group,
      course: courses(:As17), # grabbed from fixtures
      wday: :saturday)
    expect(section.events.count).to eq 20

    section = FactoryGirl.create(:event_group,
      course: courses(:As17), # grabbed from fixtures
      wday: :sunday)
    expect(section.events.count).to eq 20

    section = FactoryGirl.create(:event_group,
      course: courses(:As17), # grabbed from fixtures
      wday: :monday)
    expect(section.events.count).to eq 19
  end
end
