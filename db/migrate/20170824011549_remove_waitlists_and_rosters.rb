class RemoveWaitlistsAndRosters < ActiveRecord::Migration[5.0]
  def change
    Course.all.each do |course|
      course.sections.each do |section|
        (YAML.load(section[:roster])).each do |student|
          rg = Registree.new(
            semester: course.semester,
            student_id: student,
            course: course,
            section: section)

          rg.save(validate: false)
        end
      end

      # waitlists are empty, so this is unnecessary
      # course.waitlist.each do |student|
      #   ballot = student.ballot

      #   Registree.create!(
      #     semester: c.semester,
      #     student: student,
      #     course: course,
      #     section: "waitlist",
      #     preferences: ballot.preferences)
      # end
    end

    remove_column :courses, :waitlist, :text

    remove_column :event_groups, :waitlist, :text
    remove_column :event_groups, :roster, :text
  end
end
