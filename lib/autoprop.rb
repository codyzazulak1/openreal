module Autoprop
	require 'pp'
	require 'watir'
	require 'webdrivers'

	def self.test(a,l,x)
	 puts "Starting....."
	 b = Watir::Browser.new :chrome, headless: true
 	 b.goto 'https://www.google.com'
	 puts b.title	
	 b.close 
	end

	def self.finden(address,login,p)
		#Selenium::WebDriver::Chrome.driver_path= '/usr/local/rvm/gems/ruby-2.3.1/bin/chromedriver'
		puts 'Setting up watir'
		browser = Watir::Browser.new :chrome, headless: true
		browser.goto 'https://app.autoprop.ca/user/login?next=%2Fproperty%2Fsearch'
		browser.text_field(name: 'login').set "#{login}"
	  browser.text_field(name: 'password').set "#{p}"
		browser.button(type: 'submit').click
		puts browser.title
		search_url = 'https://app.autoprop.ca/property/search'
		
		browser.goto search_url
		
		puts browser.title

		if browser.div(class: 'modal-footer').exists?
			browser.div(class: 'modal-footer').button(text: 'New Search').click
			browser.text_field(id: 'lookup').wait_until_present
		end
		
		puts "I'm at lookout "
		browser.text_field(id: 'lookup').click
		browser.send_keys "#{strip(address)[0]}"
		sleep 2
		browser.send_keys " #{strip(address)[1]}"
		sleep 2
		browser.send_keys :enter
		sleep 2
		browser.send_keys :enter

		browser.div(class: 'address-name').wait_until_present
		browser.button(class: 'btn').click

		browser.div(id: 'propertyValues').wait_until_present
		assess_div = browser.div(id: 'propertyValues')
		total_assess = assess_div.div(id: 'totalAssessed')
		ta_label = total_assess.span(class: 'taLabel').text
		ta_value = total_assess.span(class: 'taValue').text
		land_buildings = browser.div(id: 'fvProperty_totalLandAndBuilding')
		land_label = land_buildings.div(id: 'totalLandRow').span(class: 'propertyDataLabel').text
		land_value = land_buildings.div(id: 'totalLandRow').span(class: 'propertyDataValue').text

		assessedDate = total_assess.div(class: 'assessedDate').div(class: 'propertyLabelsText').text
		precentage_change = 0.5
		total_value = ta_value.split('$')
		total_value = total_value[1].split(',').join
		total_value = total_value.to_i

		require 'date'
		unless assessedDate.empty?
						last_assessed = assessedDate.split('of ')
						last_assessed = last_assessed[1]
						last_assessed = Date.parse(last_assessed)

						today = Time.now
						today = Date.parse(today.to_s)

						#Get number of months
						months = ((today.year * 12 + today.month) - (last_assessed.year * 12 + last_assessed.month)).abs
						total_value_today = ((months * percentage_change)/100 +1) * total_value
		end

		assessment = {
			total_value_today: total_value_today,
			assessed_date: assessedDate,
			assessed_date_value: total_value,
			land_value: land_value
		}
		
		puts "#{assessedDate}"
		puts "#{ta_label}: #{ta_value}"
		puts "#{land_label}: #{land_value}"
		puts "Total change for #{months} months based on 0.5\% per month: #{total_value_today.abs}"
		sleep 5

		browser.close
		puts "Assessment: #{assessment}"
		return assessment
	end


	private 

	def	strip(address)
		address = address.split(',')
		return address
	end
end	
