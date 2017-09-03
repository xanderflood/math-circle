class RemoveWaitlistsAndRosters < ActiveRecord::Migration[5.0]
  def change
    Course.each do |course|
      course.section.each do |section|
        section.roster.each do |student|
          Registree.create!(
            semester: c.semester,
            student: student,
            course: course,
            section: section)
        end
      end

      course.waitlist.each do |student|
        ballot = student.ballot

        Registree.create!(
          semester: c.semester,
          student: student,
          course: course,
          section: "waitlist",
          preferences: ballot.preferences)
      end
    end

    remove_column :courses, :waitlist, :text

    remove_column :event_groups, :waitlist, :text
    remove_column :event_groups, :roster, :text
  end
end
