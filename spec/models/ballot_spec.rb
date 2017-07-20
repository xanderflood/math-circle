require 'rails_helper'

RSpec.describe Ballot, type: :model do
  it 'should reject a ballot without a valid course' do
    # binding.pry
  end
  it 'should reject a ballot without a valid student'
  it 'should reject a ballot without a valid semester'
  it 'should reject a ballot whose course doesn\'t belong to its semester'
  it 'should reject a ballot whose sudent has already submitted a ballot this semester'
  it 'should reject a ballot whose student is not grade-qualified for thie course'
  it 'should reject a ballot whose preferences are not of the appropriate format'

  context 'preferences' do

    # TODO: things like duplicates and contiguity go here
  end

  pending "add some examples to (or delete) #{__FILE__}"
end
