class AddCourseToEventGroup < ActiveRecord::Migration[5.0]
  def change
    add_reference :event_groups, :course, foreign_key: true
  end
end
