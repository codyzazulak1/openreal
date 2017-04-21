class SitemapController < ApplicationController
	
	def index
		@properties = Property.all
    respond_to do |format|
      format.xml
    end
  end

end

