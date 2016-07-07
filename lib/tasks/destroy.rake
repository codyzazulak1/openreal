namespace :destroy do

  desc "Destroy Admins"
  task :admins, [] => :environment do
    raise "Can't run on Production" if Rails.env.production?

    Admin.all.each { |a|
      puts "Destroying Admin: #{a.first_name} #{a.last_name}"
      a.destroy
    }
  end

  desc "Destroy Agents"
  task :agents, [] => :environment do
    raise "Can't run on Production" if Rails.env.production?

    Agent.all.each { |a|
      puts "Destroying Agent: #{a.first_name} #{a.last_name}"
      a.destroy
    }
  end

  desc "Destroy Customers"
  task :customers, [] => :environment do
    raise "Can't run on Production" if Rails.env.production?

    Customer.all.each { |a|
      puts "Destroying Customer: #{a.first_name} #{a.last_name}"
      a.destroy
    }
  end

  desc "Destroy Properties"
  task :properties, [] => :environment do
    raise "Can't run on Production" if Rails.env.production?

    Property.all.each { |a|
      puts "Destroying: #{a.description}"
      a.destroy
    }
  end

  desc "Destroy users"
  task :users, [] => :environment do

    Rake::Task['destroy:admins'].execute
    Rake::Task['destroy:customers'].execute
    Rake::Task['destroy:agents'].execute

    puts "Destroyed Admins, Customers, and Agents"

  end

  desc "Destroy all / purge database"
  task :EVERYTHING, [] => :environment do
    Rake::Task['destroy:admins'].execute
    Rake::Task['destroy:properties'].execute
    Rake::Task['destroy:agents'].execute
    Rake::Task['destroy:customers'].execute
  end

end
