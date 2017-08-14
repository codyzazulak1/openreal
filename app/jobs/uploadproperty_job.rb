class UploadpropertyJob < ActiveJob::Base
  queue_as :aproperty

	require_relative '../../lib/agent_finder.rb'
	include AgentFinder

  def perform(agent_profile = [], agent_id)
  	agent = Agent.find(agent_id)

    agent_profile << {listings: AgentFinder.findPagination(AgentFinder.link_to_profile("#{agent.first_name}", "#{agent.last_name}"))}


    agent_profile << {portrait: AgentFinder.searchByName("#{agent.first_name}","#{agent.last_name}", agent.company_name)[:portrait]}

  	if agent_profile[1][:portrait]
  		agent.remote_profile_picture_url = agent_profile[1][:portrait]
  		agent.save
  	end

    agent_profile[0][:listings].each do |listing|
	    property = Property.new(
	      list_price_cents: listing[:property][:list_price_cents],
	      description: listing[:property][:description],
	      agent_id: agent.id,
	      bedrooms: listing[:property][:bedrooms] || nil,
	      bathrooms: listing[:property][:bathrooms] || nil,
	      floor_area: listing[:property][:floor_area] || nil,
	      year_built: listing[:property][:year_built] || nil,
	      dwelling_class: listing[:property][:dwelling_class] || nil,
	      status: Status.find_by(name: "Pending Approval", category: "Agent Submitted")
	    )

	    if property.save

	    	photo_arr = listing[:pictures]

	    	photo_arr.each {|src|
	    		u = property.photos.build
	    		u.remote_picture_url = src

	    		if u.save
	    			puts '###### Saved Photo'
	    		else
	    			puts '##### Failed to save photo'
	    		end
	    	}

	    end #property save close

      address = Address.new(
        address_first: "#{listing[:property][:address][:address_first]} #{listing[:property][:address][:street]}",
        address_second: listing[:property][:address][:address_second],
        street: listing[:property][:address][:street],
        city: listing[:property][:address][:city],
        postal_code: listing[:property][:address][:postal_code],
        property_id: property.id
      )
      address.save!

	  end #listing.each close

  end #perform close

end
