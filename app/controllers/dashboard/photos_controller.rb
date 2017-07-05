class Dashboard::PhotosController < ApplicationController
	 before_action :set_property, only: [:create, :destroy]

	def create
		params[:photo]['picture'].each do |p|
	 		@photo = @property.photos.create!(picture: p, property_id: @property.id)
		end
		@photos = @property.photos

		respond_to do |format|
			format.js
		end

		# if (@property != nil)
		# 	params[:photo]['picture'].each do |p|
		# 		@photos = @property.photos.create!(picture: p, property_id: @property.id)
		# 	end
		# 	respond_to do |format|
		# 		if @photos.save
		# 			format.html {redirect_to edit_dashboard_property_path(@property), notice: "Picture(s) successfully added"}
		# 			format.js {}
		# 			format.json { render json: @photos, status: :created, location: @photos}
		# 		else 
		# 			format.html {render edit_dashboard_property_path(@property), notice: "Failed uploading picture(s), try again"}
		# 			format.json {render json: @photos.errors, status: :unprocessable_entity}
		# 		end
		# 	end
		# end
	end

	def destroy
		@photo = Photo.find(params[:id])
	
		if @photo.picture.large.url == @property.featured_photo
			@property.featured_photo = ""
			@photo.destroy
			@property.save

		elsif params[:destroy_all]
			@property.photos.destroy_all
		else
			@photo.destroy
		end

		respond_to do |format|
			format.html {redirect_to edit_dashboard_property_path(@property)}
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