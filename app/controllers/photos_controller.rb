class PhotosController < ApplicationController

	def update
	  respond_to do |format|
	    if @photos.update(photos_params)
	      format.html { redirect_to dashboard_properties_path, notice: 'Photo was successfully updated.' }
	    end 
	  end
	end
end