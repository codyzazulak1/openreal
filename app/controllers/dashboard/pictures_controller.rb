class Dashboard::PicturesController < ApplicationController

  before_action :find_property

  def create

      add_more_pictures(pictures_params[:pictures])
      flash[:error] += "Failed to upload" unless @property.save

      remove_pictures_at_index(params[:deletes].map! {|u| u.to_i})
      flash[:error] += "Failed to delete image(s)" unless @property.save
      redirect_to edit_dashboard_property_path(@property)

  end

  def destroy
  end

  private

  def find_property
    @property = Property.find(params[:property_id])
  end

  def add_more_pictures(new_pictures)
    return @property.pictures if new_pictures.nil?
    pictures = @property.pictures
    pictures += new_pictures
    @property.pictures = pictures
  end

  def remove_pictures_at_index(index_arr)
    return @property.pictures if index_arr.nil? || index_arr.empty?
    remain_pictures = @property.pictures
    deleted_pictures = remain_pictures.delete_if.with_index { |r, i| index_arr.include? i } # delete the target image
    deleted_pictures.each {|i| i.try(:remove!) }
    @property.pictures = remain_pictures
  end

  def pictures_params
    params.require(:property).permit({pictures: []})
  end

end
