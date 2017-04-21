base_url = "http://#{request.host_with_port}/"

xml.instruct! :xml, :version=>"1.0"
xml.tag! 'urlset', 'xmlns' => 'http://www.sitemaps.org/schemas/sitemap/0.9', 'xmlns:xsi' => 'http://www.w3.org/2001/XMLSchema-instance', 'xsi:schemaLocation' => 'http://www.sitemaps.org/schemas/sitemap/0.9
            http://www.sitemaps.org/schemas/sitemap/0.9/sitemap.xsd' do

  xml.url {
    xml.loc base_url
    xml.changefreq("weekly")
    xml.priority(0.7)
  }
  
  xml.url {
    xml.loc base_url+'about'
    xml.changefreq("weekly")
    xml.priority(0.5)
  }
  
  xml.url {
    xml.loc base_url+'contacts'
    xml.changefreq("weekly")
    xml.priority(0.5)
  }
  

  xml.url {
  	xml.loc base_url+'listings'
    xml.changefreq("weekly")
    xml.priority(1.0)
  }
  
  xml.url {
    xml.loc base_url+'agents'
    xml.changefreq("weekly")
    xml.priority(0.5)
  }

  xml.url {
    xml.loc base_url+'howitworks'
    xml.changefreq("weekly")
    xml.priority(0.5)
  }
  xml.url {
    xml.loc base_url+'properties/new'
    xml.changefreq("weekly")
    xml.priority(0.7)
  }

  xml.url {
    xml.loc base_url+'terms'
    xml.changefreq("monthly")
    xml.priority(0.5)
  }

  xml.url {
    xml.loc base_url+'admins/sign_in'
    xml.changefreq("monthly")
    xml.priority(0.5)
  }

  @properties.each do |property|
    xml.url {
        xml.loc "#{property_url(property)}"
        xml.lastmod property.updated_at.strftime("%F")
        xml.changefreq("weekly")
        xml.priority(1.0)
      }
    
  end

end