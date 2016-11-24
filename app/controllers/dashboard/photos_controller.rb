class Dashboard::PhotosController < ApplicationController


  def destroy
    @photo = Photo.find(params[:id])
    @property = Property.find(params[:property_id])
    if @photo.destroy
      redirect_to edit_dashboard_property_path(@property)
    end
  end

  def batchdestroy
  	photos = Photo.where(id: params[:ids])
  	photoword = photos.count > 1 ? 'photos' : 'photo'
  	photoarr = []
  	photos.each do |u| photoarr.push("u.id (#{u.picture_url})") end
  	if photos.destroy_all
	  	flash[:notice] = "Deleted #{photoword} #{photoarr} from Property #{params[:property_id]} (#{Property.find(params[:property_id]).address_name})"
	  	redirect_to edit_dashboard_property_path(params[:property_id])
	  end
  end

end
