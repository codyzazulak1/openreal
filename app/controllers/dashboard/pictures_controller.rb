class Dashboard::PicturesController < ApplicationController

  before_action :find_property

  def create

      if pictures_params[:deletes]
        remove_pictures_at_index(pictures_params[:deletes].map! {|u| u.to_i})
      end

      if pictures_params[:pictures]
        add_more_pictures(pictures_params[:pictures])
      end

      @property.save

      redirect_to edit_dashboard_property_path(@property)

  end

  def destroy
  end

  private

  def find_property
    @property = Property.find(params[:property_id])
  end

  def add_more_pictures(new_pictures)
    pictures = @property.pictures
    pictures += new_pictures
    @property.pictures = pictures
  end

  def remove_pictures_at_index(index_arr)
    
    remain_pictures = @property.pictures

    deleted_pictures = remain_pictures.dup - remain_pictures.delete_if.with_index { |r, i| index_arr.include? i } # delete the target image
    del = deleted_pictures.each {|i| i.try(:remove!) }

    remain_pictures.empty? ? @property.remove_pictures! : del
    @property.pictures = remain_pictures

  end

  def pictures_params
    params.require(:property).permit({pictures: [], deletes: []})
  end

end
