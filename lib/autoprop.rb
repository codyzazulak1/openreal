module Autoprop
	require 'pp'
	require 'watir'

	def self.finden(address,login,p)
			
		chrome_bin			 		= ENV.fetch('GOOGLE_CHROME_SHIM', nil)
		google_path 				= ENV.fetch('GOOGLE_CHROME_BIN', nil)
		heroku_chromedriver = '/app/.chromedriver/bin/chromedriver'
		heroku_gochrome			= '/app/.apt/usr/bin/google-chrome'

		if Rails.env == 'production'
			Selenium::WebDriver::Chrome.driver_path = heroku_chromedriver
			browser = Watir::Browser.new :chrome, headless: true, options: {binary: heroku_gochrome}
		elsif Rails.env == 'development'
		 	browser = Watir::Browser.new :chrome, headless: true
		end

		browser.goto 'https://app.autoprop.ca/user/login?next=%2Fproperty%2Fsearch'

		browser.text_field(name: 'login').set!("#{login}")


	  browser.text_field(name: 'password').set!("#{p}")
		
		puts browser.url

		browser.button(type: 'submit').click

		search_url = 'https://app.autoprop.ca/property/search'
		
		browser.goto search_url
		
		if (browser.div(class: 'modal-footer').exists? && browser.div(class: 'modal-alert').exists?)
			browser.div(class: 'modal-footer').button(text: 'New Search').click
			browser.text_field(id: 'lookup').wait_until_present
		end
		
		browser.text_field(id: 'lookup').set!("#{self.strip(address)[0]}")
		
		sleep 2

		browser.text_field(id: 'lookup').send_keys :enter

		sleep 2 
	
		browser.send_keys :enter

		browser.div(class: 'address-name').wait_until_present

		browser.window.resize_to(1480, 850)

		#Menu Autopro
		browser.input(class: ["chosen-search-input"], index: 2).send_keys :tab
		sleep 1
		browser.div(class: ['chosen-container'], index: 2).click
		sleep 2 
		browser.li(class: ["active-result"], index: 0).click


		browser.input(class: ["chosen-search-input"], index: 2).send_keys :tab
		sleep 1
		browser.div(class: ['chosen-container'], index: 2).click
		sleep 2 
		browser.li(class: ["active-result"], index: 0).click



		sleep 2
		browser.screenshot.png
		browser.screenshot.save 'a.png'

		puts "Im on generate report page"	
		sleep 2

		
		browser.div(class: 'navigation-bar').button(class: ['btn', 'btn-primary']).click
		
		puts browser.url
		
		puts "Gathering data"
		

		#Paragon residential comparables 
		puts "comparables"
		comparable_container = browser.div(class: "paragon-res", index: 1).table(class: "table")
		puts comparable_container
		comparable_container.wait_until_present


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


	def	self.strip(address)
		address = address.split(',')
		return address
	end
end	
