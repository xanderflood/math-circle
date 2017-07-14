require 'rails_helper'

RSpec.describe Course, type: :model do
  it 'should reject a course without a valid semester'
  it 'should reject a course with a blank name'
  it 'should accept a course with a valid semester and name'

  pending "add some examples to (or delete) #{__FILE__}"
end
