require 'rails_helper'

RSpec.describe Rollcall, type: :model do
  it "should produce correct hashes from JSON attendance" do
    example_in = [
      { "1" => "0", "4" => "0", "72" => "0", "31" => "0", "9" => "0" },
      { "1" => "0", "4" => "10", "72" => "1", "31" => "0", "9" => "0" },
      {}
    ].map(&:to_json)

    example_out = [
      { 1 => 0, 4 => 0, 72 => 0, 31 => 0, 9 => 0 },
      { 1 => 0, 4 => 10, 72 => 1, 31 => 0, 9 => 0 },
      {}
    ]

    example = example_in.zip(example_out)

    semester = FactoryBot.create(:semester_with_courses)
    event = semester.courses.first.sections.first.events.first
    example.each do |k,v|
      rollcall = Rollcall.new(attendance: k, event: event)

      expect(rollcall.attendance_hash).to eq(v)
    end
  end
end
