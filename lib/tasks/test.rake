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
        description: "#{addr_formatted}"
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
