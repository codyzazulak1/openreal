class PropertiesController < ApplicationController

  def index
    @properties = Property.all
  end

  def city
    @city = params[:city]
    @properties = Property.joins(:address).where(addresses: {city: params[:city]})
    render :city
  end

  private

end
