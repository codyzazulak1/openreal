class Dashboard::PhotosController < ApplicationController
	 before_action :set_property, only: [:create]

	def create
		if (@property != nil)
			params[:photo]['picture'].each do |p|
				@photos = @property.photos.create!(picture: p, property_id: @property.id)
			end
			respond_to do |format|
				if @photos.save
					format.html {redirect_to edit_dashboard_property_path(@property), notice: "Picture(s) successfully added"}
					format.js {}
					format.json { render json: @photos, status: :created, location: @photos}
				else 
					format.html {render edit_dashboard_property_path(@property), notice: "Failed uploading picture(s), try again"}
					format.json {render json: @photos.errors, status: :unprocessable_entity}
				end
			end
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