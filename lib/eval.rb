module Evalbc

require 'pp'
require 'watir'
require 'date'

def self.finden(address)
	chrome_bin = ENV.fetch('GOOGLE_CHROME_BIN', nil)
	puts "----------CHROME BIN: #{chrome_bin}"
	chrome_shims = ENV.fetch('GOOGLE_CHROME_SHIM', nil)
	puts "-----------CHROME SHIM: #{chrome_shims}"

	chrome_opts = chrome_bin ? {"chromeOptions" => {"binary" => chrome_shims}} : {}

	cap = Selenium::WebDriver::Remote::Capabilities.chrome(chrome_opts)
	puts cap
	browser = Watir::Browser.new :chrome, headless: true, desired_capabilities: cap
	
	browser.goto 'https://evaluebc.bcassessment.ca/'

	if address.include? 'apt' 
		address = address.split('apt.')[1]
	end

	search_bar = browser.text_field(id: 'rsbSearch')

	search_bar.set "#{address}"

	browser.ul(id: "ui-id-1").wait_until_present

	sleep 2
	browser.text_field(id: 'rsbSearch').click
	browser.text_field(id: 'rsbSearch').send_keys [:down, :enter]
	sleep 2 

	#--------items
	if browser.div(id: 'totalAssessed').present?
		if browser.span(id: 'sptotalassessed').present?
			total_value = browser.span(id: 'sptotalassessed').text
		else
			total_value = "$0"
		end
		if browser.div(id: 'div_lastassessmentdate').present?
			assessed_date = browser.div(id: 'div_lastassessmentdate').text
		else
			assessed_date = 'Not available'
		end
	
	end

	#------- Land And Building seciton
	if browser.div(id: 'totalLandAndBuilding').present?
		if browser.div(id: 'totalLandRow').present?
			land = browser.span(id: 'span_Totalassessedland').text
		else
			land = '$0'
		end

		if browser.div(id: 'totalBuildingRow').present?
			building = browser.span(id: 'span_Totalassessbuilding').text
		else
			building = '$0'
		end
	else
		#land and building not available
		land = '$0 - Not available'
		building = '$0 - Not available'
	end
	
	if browser.div(id: 'previousAssessed').present?
		if browser.div(id: 'prevAssessedRow').present?
			prev_yr_val = browser.span(id: 'span_PreviousTotalAssessed').text
		else
			prev_yr_val = '$0'
		end
		
		if browser.div(id: 'prevLandRow').present?
			prev_land_price = browser.div(id: 'span_PreviousAssessedLand').text
		else
			prev_land_price = 'Not available'
		end

		if browser.div(id: 'prevBuildingRow').present?
			prev_building_price = browser.div(id: 'span_PreviousAssessedBuilding').text
		else
			prev_building_price = 'Not Available'
		end

	else
		previously_assessed = 'Not Available'
	end

	percentage_change = 0.5
	
	unless ((total_value.nil?) || (total_value.include? "$0"))
		total_value = total_value.split('$')
		total_value = total_value[1].split(',').join
		total_value = total_value.to_i
	end

	unless (assessed_date.nil? || assessed_date.empty?)
		last_assessed = assessed_date.split('of ')
		last_assessed = last_assessed[1]
		last_assessed = Date.parse(last_assessed)
		
		today = Time.now
		today = Date.parse(today.to_s)

		#Get number of months
		months = ((today.year * 12 + today.month) - (last_assessed.year * 12 + last_assessed.month)).abs
		total_value_today = ((months * percentage_change)/100 + 1) * total_value
	end

	if (total_value_today == 0 || total_value_today.nil?)
		total_value_today = "Couldn't be calculated"
	end
	
	url = browser.url

	assessment = {
		total_value_today: total_value_today,
		assessed_date: assessed_date,
		assessed_date_value: total_value,
		land_value: land,
		building_value: building,
		url: url
	}


	browser.close 
	return assessment
end
end
