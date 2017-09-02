# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require_relative 'config/application'

Rails.application.load_tasks

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
