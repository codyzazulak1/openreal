namespace :seed do

  desc "Production"
  task :prod, [] => :environment do

    Admin.create(first_name: 'Steven', email: 'stevenk@openreal.ca', password: 'skopenadmin', password_confirmation: 'skopenadmin')
    Admin.create(first_name: 'Fio', email: 'fiorellal@openreal', password: 'flopenadmin', password_confirmation: 'flopenadmin')
    Admin.create(first_name: 'Cody', email: 'codyz@openreal.ca', password: 'czopenadmin', password_confirmation: 'czopenadmin')

    customer_submitted = ["Unappraised", "Awaiting Response", "Closing"]
    agent_submitted = ["Unapproved", "Approved"]
    owned_properties = ["Unlisted", "Listed", "Archived"]

    customer_submitted.each do |u|
      Status.create(category: "Customer Submitted", name: u)
      puts "Customer Submitted ------ #{u}"
    end

    agent_submitted.each do |u|
      Status.create(category: "Agent Submitted", name: u)
      puts "Agent Submitted ------ #{u}"
    end

    owned_properties.each do |u|
      Status.create(category: "Owned Properties", name: u)
      puts "Owned Properties ------ #{u}"
    end

    arr =
    [
      "bathroom",
      "pool",
      "basement",
      "kitchen"
    ]

    arr.each do |u|

      Upgrade.create(name: u)

    end

  end

  desc "Everything"
  task :everything, [] => :environment do
    Rake::Task['seed:users'].execute
    Rake::Task['seed:statuses'].execute
    Rake::Task['seed:upgrades'].execute
    Rake::Task['seed:properties'].execute
    Rake::Task['seed:photos'].execute

  end

  desc "All user seeds"
  task :users, [] => :environment do

    Rake::Task['seed:admins'].execute
    Rake::Task['seed:agents'].execute
    Rake::Task['seed:customers'].execute

  end

  desc "Seed 3 Admins"
  task :admins, [] => :environment do
    raise "Can't run on Production" if Rails.env.production?

    Admin.create(first_name: "Steven", last_name: "Kang", email: "steven@admin.com", password: "openadminsk", password_confirmation: "openadminsk")
    Admin.create(first_name: "Fio", last_name: "Leon-Gomez", email: "fiol@openreal.ca", password: "openadminfl", password_confirmation: "openadminfl")
    Admin.create(first_name: "Cody", last_name: "Zazulak", email: "codyz@openreal.ca", password: "openadmincz", password_confirmation: "openadmincz")

    puts "Steven Admin"
    puts "stevenk@openreal.ca"
    puts "openadminsk"
    puts "-------------------------------"
    puts "Fio Admin"
    puts "fio@openreal.ca"
    puts "openadminfl"
    puts "-------------------------------"
    puts "Cody Admin"
    puts "patrick@openreal.ca"
    puts "openadmincz"
    puts "-------------------------------"
  end


  desc "Add status options"
  task :statuses, [] => :environment do
    raise "Can't run on Production" if Rails.env.production?

    customer_submitted = ["Unappraised", "Awaiting Response", "Closing"]
    agent_submitted = ["Unapproved", "Approved", "Pending Approval"]
    owned_properties = ["Unlisted", "Listed", "Archived"]

    customer_submitted.each do |u|
      Status.create(category: "Customer Submitted", name: u)
      puts "Customer Submitted ------ #{u}"
    end

    agent_submitted.each do |u|
      Status.create(category: "Agent Submitted", name: u)
      puts "Agent Submitted ------ #{u}"
    end

    owned_properties.each do |u|
      Status.create(category: "Owned Properties", name: u)
      puts "Owned Properties ------ #{u}"
    end

  end

  desc "Add upgrade options"
  task :upgrades, [] => :environment do
    raise "Can't run on Production" if Rails.env.production?

    arr =
    [
      "bathroom",
      "pool",
      "basement",
      "kitchen"
    ]

    arr.each do |u|

      Upgrade.create(name: u)

    end

  end

end
