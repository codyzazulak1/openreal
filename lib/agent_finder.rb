module AgentFinder

  require 'indirizzo/address'

  @mech = Mechanize.new
  def AgentFinder.searchByName(firstname, lastname, company)


    @mech.get(AgentFinder.urlbuilder(firstname, lastname, company)) { |page|
      
      res = page.search('article.agent').first

      resObj = {

        full_name: res.search('div.agent-heading span').text,
        email: res.search('.agent-contact a').attribute('href').to_s[7..-1],
        portrait: "https://www.sutton.com#{res.search('div.photo img').attribute("data-src")}"

      }

      link_to_profile = res.search('div.body div.photo a').attribute("href");

      resObj[:listings] = AgentFinder.pullListings(link_to_profile)
      byebug
      pp resObj
      return resObj

    }

  end

  def AgentFinder.urlbuilder(first_name, last_name, company)
    # byebug
    url = ''

    case company
      when "Sutton"
        url = "https://www.sutton.com/agents/?search_agent=#{first_name}+#{last_name}"
    end

    return url

  end

  def AgentFinder.pullListings(link_to_profile)
    listings_array = []
    @mech.get(link_to_profile) { |page|
      listings = page.search('.listing')
      listing_links = listings.map { |listing|
        listing.search('li.view-detailsOPTION a').attribute('href')
      }

      listing_links.each { |url|
        @mech.get(url) { |p|

          address = p.xpath('//span[@itemprop="streetAddress"]').text
          parsed_address = Indirizzo::Address.new(address)
          postal_code = p.search('div.keyvalset')[1].search('span').last.text
   
          city = p.xpath('//span[@itemprop="addressLocality"]').text

          obj = {
            address: { 
              address_first: parsed_address.number,
              address_second: parsed_address.prenum || nil,
              street: parsed_address.street[0].titleize,
              city: city,
              postal_code: postal_code
            },
            description: p.search('p.remarks').first.text
          }

          listings_array.push(obj)
        }
      }
    }
    return listings_array
  end
end
