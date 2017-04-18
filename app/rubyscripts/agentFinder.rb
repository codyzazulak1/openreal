# https://www.sutton.com/agents/?search_agent='agent'&search_state=&sortorder=ASC-timestamp&letter=

module AgentFinder

  def theThing(name)

    mech = Mechanize.new

    mech.get(urlbuilder(name)) { |p|

      puts p

    }

  end

  private

  def urlbuilder(name)

    return "https://www.sutton.com/agents/?search_agent=#{name}"

  end

end
