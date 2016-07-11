namespace :commands do

  desc "Commands"
  task :list, [] => :environment do
    raise "You can't run this on Production" if Rails.env.production?

    overall_commands = [
    ["db:rebuild", "Rebuilds database and seeds everything"],
    ]
    seed_commands = [
    ["seed:admins", "Seeds 3 admins (Same names every time)"],
    ["seed:agents", "Seeds 3 agents (Same names every time)"],
    ["seed:customers", "Seeds 3 customers (Same names every time)"],
    ["seed:users", "Seeds all of the above"],
    ["seed:properties", "Seeds 20 properties (Random attributes)"],
    ]
    destroy_commands = [
    ["destroy:admins", "Destroys all Admins"],
    ["destroy:agents", "Destroys all Agents"],
    ["destroy:customers", "Destroys all Customers"],
    ["destroy:properties", "Destroys all Properties"],
    ["destroy:EVERYTHING", "Destroys everything"]
    ]

    puts ""
    puts "START ALL COMMANDS WITH 'db_tasks'".center(100)
    puts ""
    puts "Overall Commands".center(100, " - ")
    puts ""
    overall_commands.each { |c|
      puts "#{c[0].ljust(50)} #{c[1].rjust(50)}"
    }
    puts ""
    puts "Seed Commands".center(100, " - ")
    puts ""
    seed_commands.each { |c|
      puts "#{c[0].ljust(50)} #{c[1].rjust(50)}"
    }
    puts ""
    puts "Destroy Commands".center(100, " - ")
    puts ""
    destroy_commands.each { |c|
      puts "#{c[0].ljust(50)} #{c[1].rjust(50)}"
    }
    puts ""

  end

end

namespace :db do

  desc "Rebuild all the things"
  task :rebuild, [] => :environment do
    raise "You can't run this on Production" if Rails.env.production?

    puts "Dropping..."
    Rake::Task['db:drop'].execute
    puts "Creating..."
    Rake::Task['db:create'].execute
    puts "Migrating..."
    Rake::Task['db:migrate'].execute
    puts "Seeding users..."
    Rake::Task['seed:users'].execute
    puts "Seeding properties..."
    Rake::Task['seed:properties'].execute
    puts "Done!"

  end

end
