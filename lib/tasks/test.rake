namespace :seed do

  desc "seed properties"
  task :properties, [] => :environment do
    raise "Can't run on Production" if Rails.env.production?

    city = "address=Vancouver"
    region = "region=ca"

    request_uri = "https://maps.googleapis.com/maps/api/geocode/json?"
    key = "&key=#{ENV['GEOCODER']}"
    params = "#{city}&#{region}"
    url = "#{request_uri}#{params}#{key}"

    vancouver_json = JSON.parse(open(url).read)["results"]

    boundaries = vancouver_json[0]["geometry"]["bounds"]
    ne = boundaries["northeast"]
    sw = boundaries["southwest"]

    25.times do


      loop do
        @rand_lat = rand(sw['lat']..ne['lat'])
        @rand_lng = rand(sw['lng']..ne['lng'])

        reverse_params = "latlng=#{@rand_lat},#{@rand_lng}"
        reverse_url = "#{request_uri}#{reverse_params}#{key}"
        @place_json = JSON.parse(open(reverse_url).read)["results"]

        break if @place_json &&
          @place_json[0]["address_components"][0]["types"] == ["street_number"]
      end

      addr = @place_json[0]
      addr_formatted = addr["formatted_address"]
      addr_c = addr["address_components"]

      addr_first = "#{addr_c[0]["long_name"]} #{addr_c[1]["long_name"]}"
      addr_postal = addr_c[-1]["long_name"]
      addr_city = addr_c[4]["long_name"]
      addr_street = addr_c[1]["long_name"]

      property = Property.create(
        description: "Elegance & luxury exudes in this amazing Chandler home in a gated community! Enter through the ornate wrought iron gate & behold the beauty of travertine tile, wood shutters, built in bookcases, fireplaces, and the professional interior design throughout. Chef's kitchen features top of the line stainless steel appliances, dark wood cabinets, granite countertops & backsplash, 2 wine coolers, center island, breakfast bar & a walk in pantry. 14' ceiling in the living room. Master suite is complete with sitting area, fireplace, separate exit, and luxurious spa like bathroom. Each spacious bedroom has direct access to a bath. Resort style backyard with sparkling blue pool, extended covered patio, built in BBQ and a firepit both with ample seating. Multiple fruit trees in the courtyard/backyard.",
        floor_area: rand(1900..2100),
        lot_length: rand(210..240),
        lot_width: rand(200..220),
        title_to_land: "Freehold",
        pid: rand(1000000..6000000),
        building_type: "House",
        property_type: "Single Family",
        stories: rand(1..3),
        bedrooms: rand(2..5),
        bathrooms: rand(2..4),
        fireplaces: rand(1..15)
      )

      Address.create(
        address_first: addr_first,
        street: addr_street,
        city: addr_city,
        postal_code: addr_postal,
        latitude: @rand_lat,
        longitude: @rand_lng,
        property_id: property.id
      )

      puts "#{property.description} CREATED"

    end

  end

end
