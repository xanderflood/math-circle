module EnrollmentHelper
 include ActiveRecord::Sanitization::ClassMethods

  def self.semester_enrollment
    ActiveRecord::Base.connection.execute(
      "SELECT
        semesters.id, COUNT(student_semesters.stu_id)
      FROM (
        SELECT
          COALESCE(
            ballots.student_id,
            registrees.student_id) AS stu_id,
          COALESCE(
            ballots.semester_id,
            registrees.semester_id) AS sem_id
        FROM
          registrees FULL JOIN ballots
          ON registrees.student_id = ballots.student_id
            AND registrees.semester_id = ballots.semester_id
      ) AS student_semesters
      FULL JOIN semesters
        ON semesters.id = student_semesters.sem_id
      GROUP BY semesters.id;")
    .entries.map do |e|
      [e["id"], e["count"]]
    end.to_h
  end

  def self.course_enrollment semester
    ActiveRecord::Base.connection.execute(
      "SELECT
        courses.id, COUNT(registrees.student_id)
      FROM
        courses FULL JOIN registrees
        ON registrees.course_id = courses.id
      WHERE courses.semester_id = #{sanitize_sql(semester.id)}
      GROUP BY courses.id;")
    .entries.map do |e|
      [e["id"], e["count"]]
    end.to_h
  end

  def self.section_enrollment course
    ActiveRecord::Base.connection.execute(
      "SELECT
        id AS id, COUNT(student) AS count
      FROM
        ( SELECT
            *
          FROM
            ( SELECT egs.id AS id, regs.student_id AS student
              FROM
              ( SELECT *
                FROM event_groups
                WHERE event_groups.course_id = #{sanitize_sql(course.id)}
              ) AS egs
              FULL JOIN
              ( SELECT *
                FROM registrees
                WHERE registrees.course_id = #{sanitize_sql(course.id)}
              ) AS regs
              ON regs.section_id = egs.id
            ) AS section_students
            UNION (SELECT NULL AS id, NULL AS student)
        ) AS with_placeholder
      GROUP BY id;")
    .entries.map do |e|
      [e["id"], e["count"]]
    end.to_h
  end
end