namespace :db_tasks do

  desc "Commands"
  task :stevenisgreat, [] => :environment do
    raise "You can't run this on Production" if Rails.env.production?
    overall_commands = [
    [":allthethings", "Rebuilds database and seeds everything"],
    ]
    seed_commands = [
    [":seed_admins", "Seeds 3 admins (Same names every time)"],
    [":seed_agents", "Seeds 3 agents (Same names every time)"],
    [":seed_customers", "Seeds 3 customers (Same names every time)"],
    [":seed_users", "Seeds all of the above"],
    [":seed_properties", "Seeds 20 properties (Random attributes)"],
    ]
    destroy_commands = [
    [":destroy_admins", "Destroys all Admins"],
    [":destroy_agents", "Destroys all Agents"],
    [":destroy_customers", "Destroys all Customers"],
    [":destroy_properties", "Destroys all Properties"],
    [":DESTROY", "Destroys everything"]
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

  desc "Rebuild all the things"
  task :allthethings, [] => :environment do
    raise "You can't run this on Production" if Rails.env.production?

    puts "Dropping..."
    Rake::Task['db:drop'].execute
    puts "Creating..."
    Rake::Task['db:create'].execute
    puts "Migrating..."
    Rake::Task['db:migrate'].execute
    puts "Seeding users..."
    Rake::Task['db_tasks:seed_users'].execute
    puts "Seeding properties..."
    Rake::Task['db_tasks:seed_properties'].execute
    puts "Done!"

  end

  desc "Seed 3 Admins"
  task :seed_admins, [] => :environment do
    raise "Can't run on Production" if Rails.env.production?

    Admin.create(first_name: "Steven", last_name: "Admin", email: "steven@admin.com", password: "butts1", password_confirmation: "butts1")
    Admin.create(first_name: "Patrick", last_name: "Admin", email: "shiming@admin.com", password: "butts1", password_confirmation: "butts1")
    Admin.create(first_name: "Shiming", last_name: "Admin", email: "patrick@admin.com", password: "butts1", password_confirmation: "butts1")

    puts "Steven Admin"
    puts "steven@admin.com"
    puts "butts1"
    puts "-------------------------------"
    puts "Shiming Admin"
    puts "shiming@admin.com"
    puts "butts1"
    puts "-------------------------------"
    puts "Patrick Admin"
    puts "patrick@admin.com"
    puts "butts1"
    puts "-------------------------------"
  end

  desc "Seed 3 Agents"
  task :seed_agents, [] => :environment do
    raise "Can't run on Production" if Rails.env.production?

    Agent.create(first_name: "Steven", last_name: "Agent", email: "steven@agent.com", password: "butts1", password_confirmation: "butts1")
    Agent.create(first_name: "Patrick", last_name: "Agent", email: "shiming@agent.com", password: "butts1", password_confirmation: "butts1")
    Agent.create(first_name: "Shiming", last_name: "Agent", email: "patrick@agent.com", password: "butts1", password_confirmation: "butts1")

    puts "Steven Agent"
    puts "steven@agent.com"
    puts "butts1"
    puts "-------------------------------"
    puts "Shiming Agent"
    puts "shiming@agent.com"
    puts "butts1"
    puts "-------------------------------"
    puts "Patrick Agent"
    puts "patrick@agent.com"
    puts "butts1"
    puts "-------------------------------"
  end

  desc "Seed 3 Customers"
  task :seed_customers, [] => :environment do
    raise "Can't run on Production" if Rails.env.production?

    Customer.create(first_name: "Steven", last_name: "Customer", email: "steven@customer.com", password: "butts1", password_confirmation: "butts1")
    Customer.create(first_name: "Patrick", last_name: "Customer", email: "shiming@customer.com", password: "butts1", password_confirmation: "butts1")
    Customer.create(first_name: "Shiming", last_name: "Customer", email: "patrick@customer.com", password: "butts1", password_confirmation: "butts1")

    puts "Steven Customer"
    puts "steven@customer.com"
    puts "butts1"
    puts "-------------------------------"
    puts "Shiming Customer"
    puts "shiming@customer.com"
    puts "butts1"
    puts "-------------------------------"
    puts "Patrick Customer"
    puts "patrick@customer.com"
    puts "butts1"
    puts "-------------------------------"
  end

  desc "Seed 20 properties"
  task :seed_properties, [] => :environment do

    raise "Can't run on Production" if Rails.env.production?

    cities = ["Langley", "Surrey", "Vancouver", "Burnaby"]

    arr = (1..20).map { |n| Property.create(description: "House number #{n}") }
    fake = Faker::Address
    arr.each { |p|
      puts p.description << " created!"
      p.address = Address.create(
        city: cities.sample,
        address_first: fake.street_address,
        postal_code: fake.zip,
        latitude: BigDecimal(fake.latitude),
        longitude: BigDecimal(fake.longitude)
      )
      p.save
    }

  end

  desc "Destroy Admins"
  task :destroy_admins, [] => :environment do
    raise "Can't run on Production" if Rails.env.production?

    Admin.all.each { |a|
      puts "Destroying Admin: #{a.first_name} #{a.last_name}"
      a.destroy
    }
  end

  desc "Destroy Agents"
  task :destroy_agents, [] => :environment do
    raise "Can't run on Production" if Rails.env.production?

    Agent.all.each { |a|
      puts "Destroying Agent: #{a.first_name} #{a.last_name}"
      a.destroy
    }
  end

  desc "Destroy Customers"
  task :destroy_customers, [] => :environment do
    raise "Can't run on Production" if Rails.env.production?

    Customer.all.each { |a|
      puts "Destroying Customer: #{a.first_name} #{a.last_name}"
      a.destroy
    }
  end

  desc "Destroy Properties"
  task :destroy_properties, [] => :environment do
    raise "Can't run on Production" if Rails.env.production?

    Property.all.each { |a|
      puts "Destroying: #{a.description}"
      a.destroy
    }
  end

  desc "Destroy all / purge database"
  task :DESTROY, [] => :environment do
    Rake::Task['db_tasks:destroy_admins'].execute
    Rake::Task['db_tasks:destroy_properties'].execute
    Rake::Task['db_tasks:destroy_agents'].execute
    Rake::Task['db_tasks:destroy_customers'].execute
  end

  desc "All user seeds"
  task :seed_users do
    Rake::Task['db_tasks:seed_admins'].execute
    Rake::Task['db_tasks:seed_agents'].execute
    Rake::Task['db_tasks:seed_customers'].execute
  end

end
