module AgentFinder

  require 'indirizzo/address'

  @mech = Mechanize.new
  def AgentFinder.searchByName(firstname, lastname, company)


    @mech.get(AgentFinder.urlbuilder(firstname, lastname, company)) { |page|
      
      no_agent = page.search('div.rewmodule_content p')
      
      res = page.search('article.agent').first
      
      unless res.blank? || !(no_agent.blank?)

        resObj = {

          full_name: res.search('div.agent-heading span').text,
          email: res.search('.agent-contact a').attribute('href').to_s[7..-1],
          portrait: "https://www.sutton.com#{res.search('div.photo img').attribute("data-src")}"

        }

        link_to_profile = res.search('div.body div.photo a').attribute("href");

        # AgentFinder.findPagination in case there's multiple pages of properties: 

        resObj[:listings] = AgentFinder.findPagination(link_to_profile)
        byebug
        return resObj

      else
        return nil
      end
      }

  end

  def AgentFinder.urlbuilder(first_name, last_name, company)

    url = ''

    case company
      when "Sutton"
        url = "https://www.sutton.com/agents/?search_agent=#{first_name}+#{last_name}"
    end

    return url

  end

  def AgentFinder.findPagination(listings_array = [], link_to_profile)
    # y check if pagination is on the page
    # y if pagination
      # y click on pagination
      # y redo AgentFinder.pullListings
        # y should add the other listings to the array passed to method
      # X check listings array is not repeated properties (Might be its own method?)
      # y return listings array
    # y else 
      # y Don't do anything
    # y end
    ## START -------------------------------------------
  
    @mech.get(link_to_profile) {|page| 
      puts "LISTINGS ARRAY: #{listings_array.count}"
      pagination_div = page.search('div.pagination')

      if !(pagination_div.empty?)

        unless listings_array
          listings_array = []
        end

        AgentFinder.pullListings(link_to_profile).map { |listing| listings_array.push(listing)}

        #check for next pages available
        np = pagination_div.map {|a| 
          if !(a.search('a.next').blank?)
            a.search('a.next').attribute('href').value
          else 
            false
          end
        }

        if np[0] != false 
          next_page = "https://www.sutton.com" + np[0]
        else
          next_page = false
        end

        unless next_page.blank?
          puts "INSIDE NEXT PAGE"
          AgentFinder.findPagination(listings_array, next_page)
        else
          listings_array
        end 

      else #no pagination
        puts "NO PAGINATION"
        listings_array = AgentFinder.pullListings(link_to_profile)
      end

      return listings_array
    }

  end

  def AgentFinder.pullListings(link_to_profile)
    listings_array = []
    puts "----------------"
    puts "BUILDING A LIST"
   

    @mech.get(link_to_profile) { |page|
      listings = page.search('.listing')

      unless listings.blank?
        listing_links = listings.map { |listing|
          listing.search('li.view-detailsOPTION a').attribute('href')
        }

        listing_links.each { |url|
          @mech.get(url) { |p|

            address = p.xpath('//span[@itemprop="streetAddress"]').text
            if address != ''
              parsed_address = Indirizzo::Address.new(address)
            else
              parsed_address = nil
              address = 'No Address'
            end

            postal_code = p.search('div.keyvalset')[1].search('span').last.text
            price_cents = p.xpath('//span[@itemprop="price"]').text.to_i * 100
            city = p.xpath('//span[@itemprop="addressLocality"]').text

            essential_info = p.search('div.keyvalset').first
            interior_info = p.search('div.keyvalset')[-2]

            # Check for commercial reale state
            type_array = ['Retail', 'Business', 'Office']
            res = ''
            essential_info.search('.keyval').each {
              |kv|
              kv_title = kv.search('strong').text
              kv_text = kv.search('span').text

              case kv_title
                when 'Type'
                  if (type_array.map {|type| type == kv_text}.any?)
                    res = 'Deny'
                    break
                  else
                    res = 'Pass'
                  end
                  
              end
            }

            if res == 'Pass'

              bedrooms = nil
              bathrooms = nil
              square_footage = nil
              year_built = nil
              building_type = nil
              stories = nil
              fireplaces = nil

              essential_info.search('.keyval').each { |kv|
                kv_title = kv.search('strong').text
                case kv_title
                  when 'Bedrooms'
                    bedrooms = kv.search('span').text.to_i
                  when 'Bathrooms'
                    bathrooms = kv.search('span').text.to_i
                   
                  when 'Square Footage'
                    square_footage = kv.search('span').text.split(',').join.to_i
                    
                  when 'Year Built'
                    year_built = kv.search('span').text.to_i
                  when 'Sub-Type'
                    building_type = kv.search('span').text
                end
              }

              interior_info.search('keyval').each { |kv|
                kv_title = kv.search('strong').text
                case kv_title
                  when '# of Stories'
                    stories = kv.search('span').text.to_i
                  when '# of Fireplaces'
                    fireplaces = kv.search('span').text.to_i
                end
              }

              slider_array = p.search('div.slide')
        
              src_array = slider_array.map { |slider|
                slider.search('img').first.attribute('data-src').value
              }
              
              obj = {
                property: {
                  address: {
                    address_first: parsed_address.number,
                    address_second: parsed_address.prenum || nil,
                    street: (parsed_address.street[0].nil? || parsed_address.nil?) ? (parsed_address.street[0] = '') : parsed_address.street[0].titleize,
                    city: city,
                    postal_code: postal_code
                  },
                  description: p.search('p.remarks').first.text,
                  list_price_cents: price_cents,
                  bedrooms: bedrooms,
                  bathrooms: bathrooms,
                  floor_area: square_footage,
                  year_built: year_built,
                  building_type: building_type,
                  number_of_floors: stories,
                  fireplaces: fireplaces
                },
                pictures: src_array
              }

              listings_array.push(obj)
            elsif res == "Deny"
              next
            end
          }
        }
    end
    }
    puts "Array count: #{listings_array.count}"
    return listings_array
  end
end
