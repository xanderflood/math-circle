require 'rails_helper'

RSpec.describe EventGroup, type: :model do
  it 'should reject an event_group with a roster that is not an array of strings'
  it 'should reject an event_group with a waitlist that is not an array of strings'
  it 'should reject an event_group without a valid course'
  it 'should create the appropriate number of events for its semester'

  pending "add some examples to (or delete) #{__FILE__}"
end
