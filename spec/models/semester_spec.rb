require 'rails_helper'

RSpec.describe Semester, type: :model do
  fixtures :semesters

  it 'should sort in reverse chronological order by start date' do
    prev_semester = nil
    first         = true
    Semester.all.each do |semester|
      if first
        prev_semester = semester
        first         = false
        next
      end

      expect(prev_semester.start).to be >= semester.start
      prev_semester = semester
    end
  end

  it 'should not accept a blank name' do
    semester = Semester.new(name: '', start: Date.today, end: Date.today + 1)

    expect(semester.save).to eq false
  end

  it 'should not accept date out of order' do
    semester = Semester.new(name: 'le semestre', start: Date.today + 1, end: Date.today)

    expect(semester.save).to eq false
  end

  it 'should not accept a valid name and dates' do
    semester = Semester.new(name: 'le semestre', start: Date.today, end: Date.today + 1)

    expect(semester.save).to eq true
  end
end
