require 'rails_helper'

RSpec.describe EventGroup, type: :model do
  fixtures :semesters
  fixtures :courses
  fixtures :event_groups

  it 'should reject an event_group with a roster that is not an array of integers' do
    section = Course.first.sections.new(
      wday: :monday,
      time: Time.now,
      waitlist: [:a, :b, :c],
      capacity: 10)

    expect(section.save).to eq false

    section = Course.first.sections.new(
      wday: :monday,
      time: Time.now,
      waitlist: [:a, 12, "1"],
      capacity: 10)

    expect(section.save).to eq false

    section = Course.first.sections.new(
      wday: :monday,
      time: Time.now,
      waitlist: [nil, nil, "1"],
      capacity: 10)

    expect(section.save).to eq false

    [{}, {a: 2, b: 4}].each do |hash|
      expect do
        Course.first.sections.new(
          wday: :monday,
          time: Time.now,
          waitlist: hash,
          capacity: 10)
      end.to raise_error ActiveRecord::SerializationTypeMismatch
    end
  end

  it 'should reject an event_group with a roster that is too large' do
    section = Course.first.sections.new(
      wday: :monday,
      time: Time.now,
      roster: [1, 2, 3],
      capacity: 2)

    expect(section.save).to eq false

    section.capacity = 3

    expect(section.save).to eq true
  end

  it 'should reject an event_group with a waitlist that is not an array of integers' do
    section = Course.first.sections.new(
      wday: :monday,
      time: Time.now,
      roster: [:a, :b, :c],
      capacity: 10)

    expect(section.save).to eq false

    section = Course.first.sections.new(
      wday: :monday,
      time: Time.now,
      roster: [:a, 12, "1"],
      capacity: 10)

    expect(section.save).to eq false

    section = Course.first.sections.new(
      wday: :monday,
      time: Time.now,
      roster: [nil, nil, "1"],
      capacity: 10)

    expect(section.save).to eq false

    [{}, {a: 2, b: 4}].each do |hash|
      expect do
        Course.first.sections.new(
          wday: :monday,
          time: Time.now,
          roster: hash,
          capacity: 10)
      end.to raise_error ActiveRecord::SerializationTypeMismatch
    end
  end

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
    section = Course.first.sections.new(
      wday: :monday,
      time: Time.now,
      capacity: 10)

    expect(section.save).to eq true
    expect(section.roster).to eq []
    expect(section.waitlist).to eq []
  end

  it 'should accept an event_group with a valid waitlist and roster specified' do
    section = Course.first.sections.new(
      wday: :monday,
      time: Time.now,
      waitlist: [],
      roster: [],
      capacity: 10)

    expect(section.save).to eq true
    section = Course.first.sections.new(
      wday: :monday,
      time: Time.now,
      waitlist: [1, 2, 3, 4],
      roster: [5, 6, 7, 8],
      capacity: 10)

    expect(section.save).to eq true
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

  it 'should require the waitlist and roster to contain valid student ids' do
    student = FactoryGirl.create(:student)
    id      = student.id
    student.delete

    section = EventGroup.create(
      course: courses(:As18), # grabbed from fixtures
      wday: :sunday,
      roster: [id])
    expect(section.save).to be false
  end
end
