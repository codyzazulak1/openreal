module AgentFinder

  def self.searchByName(name, company)

    mech = Mechanize.new

    mech.get(self.urlbuilder(name, company)) { |page|

      res = page.search('article.agent').first

      resObj = {

        full_name: res.search('div.agent-heading span').text,
        email: res.search('.agent-contact a').attribute('href').to_s[7..-1],
        portrait: "https://www.sutton.com#{res.search('div.photo img').attribute("data-src")}"

      }

      return resObj

    }

  end

  def self.urlbuilder(name, company)

    url = ''

    case company
      when "Sutton"
        url = "https://www.sutton.com/agents/?search_agent=#{name}"
    end

    return url

  end

end
