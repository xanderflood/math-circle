class CopyCapacitiesOver < ActiveRecord::Migration[5.0]
  def change
    EventGroup.all.each do |s|
      s.update!(capacity: s.course.capacity) if s.capacity == 0
    end
  end
end
