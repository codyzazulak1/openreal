class PhotosController < ApplicationController
 # before_action :set_upload, only: [:show, :edit, :update, :destroy]


	def show
	end

	def new
		@photo = Photos.new
	end

	def edit
		
	end
	def create
    @photo = Photo.new(photo_params)
 
    if @photo.save
      redirect_to dashboard_properties_path, notice: 'Photo was successfully created.'
    end
  end

  def update
    if @photo.update(photo_params)
      redirect_to dashboard_properties_path, notice: 'Upload attachment was successfully updated.'
    end
  end

	# def update
	#   respond_to do |format|
	#     if @photos.update(photo_params)
	#       format.html { redirect_to dashboard_properties_path, notice: 'Photo was successfully updated.' }
	#     end 
	#   end
	end

	private

	# def set_upload
 #    @upload = Photo.find(params[:id])
 #  end

	def photo_params
		params.require(:photos).permit(:property_id, :picture)
		
	end
end