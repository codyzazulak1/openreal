namespace :db_tasks do
  desc "Rebuild whole database"
  task :allthethings, [] => :environment do
    raise "You can't run this on Production" if Rails.env.production?

    Rake::Task['db:drop'].execute
    Rake::Task['db:create'].execute
    Rake::Task['db:migrate'].execute

  end
end
