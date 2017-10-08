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


Admin.create(first_name: "Steven", last_name: "Kang", email: "stevenk@openreal.ca", password: "openadminsk", password_confirmation: "openadminsk")
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
