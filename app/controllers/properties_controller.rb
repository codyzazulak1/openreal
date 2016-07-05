class PropertiesController < ApplicationController

  def index
    @properties = Property.all
  end

  def city
    @city = params[:city].downcase.capitalize!
    @properties = Property.joins(:address).where(:addresses => {:city => @city})
    render :city
  end

  def cities
    @addresses = Address.select(:city).distinct
    render :cities
  end
# Test comment for git

  private

end
