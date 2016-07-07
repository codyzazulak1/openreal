namespace :seed do

  desc "All user seeds"
  task :users, [] => :environment do

    Rake::Task['seed:admins'].execute
    Rake::Task['seed:agents'].execute
    Rake::Task['seed:customers'].execute

  end

  desc "Seed 3 Admins"
  task :admins, [] => :environment do
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
  task :agents, [] => :environment do
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
  task :customers, [] => :environment do
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
  task :properties, [] => :environment do

    raise "Can't run on Production" if Rails.env.production?

    cities = ["Langley", "Surrey", "Vancouver", "Burnaby"]

    arr = (1..20).map { |n| Property.create(description: "House number #{n}") }
    fake = Faker::Address
    arr.each { |p|
      puts p.description
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

end
