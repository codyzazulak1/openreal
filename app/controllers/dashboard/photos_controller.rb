class Dashboard::PhotosController < ApplicationController
	 before_action :set_property, only: [:create]

	def create
		if (@property != nil) || photos_params.empty?
			params[:photo]['picture'].each do |p|
				@photos = @property.photos.create(picture: p, property_id: @property.id)
			end

			flash[:notice] = "Uploaded photo(s) successfully"
			redirect_to :back
		else 
			flash[:error] = "Failed uploading photos"
			redirect_to edit_dashboard_property(@property)
		end
	end

	def destroy
		@photo = Photo.find(params[:id])
		@photo.destroy

		respond_to do |format|
			format.js { render template: 'dashboard/properties/destroy.js.erb', layout: false}
		end
	end

	private

	def set_property
		@property = Property.find(params[:property_id])
	end

	def photos_params
		params.require(:photo).permit!
	end

end


