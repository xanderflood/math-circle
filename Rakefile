# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require_relative 'config/application'

Rails.application.load_tasks

namespace :levels do
  # retroactively refactor the database to eliminate trace of
  # the workaround that was used prior to v2.0 (dynamic course levels)
  task :hotfix => [:environment] do
    # create new levels
    mLevels = ["A", "B", "C"].map do |l|
      level = Level.find_by(name: "Middle School #{l}")

      if level.nil?
        warn "Middle School #{l} not found - creating instead."
        level = Level.create!(name: "Middle School #{l}", active: true, min_grade: 6, max_grade: 8)
      end

      [l, level]
    end.to_h

    hLevels = ["A", "B"].map do |l|
      level = Level.find_by(name: "High School #{l}")

      if level.nil?
        warn "Middle School #{l} not found - creating instead."
        level = Level.create!(name: "High School #{l}", active: true, min_grade: 9, max_grade: 12)
      end

      [l, level]
    end.to_h

    # reassign existing courses
    Course.all.each do |course|
      if course.name.downcase.include? "middle"
        level = mLevels[course.name[-1]]

        puts "updating course #{course.name} to level #{level}"
        course.update(level: level)
      elsif course.name.downcase.include? "high"
        level = hLevels[course.name[-1]]

        puts "updating course #{course.name} to level #{level}"
        course.update(level: level)
      end
    end
  end
end

namespace :full do
  task :reset do
    ["development", "test"].each do |env|
      Rails.env = env

      ["db:drop", "db:create", "db:migrate", "db:seed"].each do |t|
        Rake::Task[t].invoke
      end
    end
  end
end
