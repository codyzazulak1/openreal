class PropertiesController < ApplicationController

  def index
    @properties = Property.all
  end

  def new
    @property = Property.new
  end

  def show
    @property = Property.find(params[:id])
  end

  def create
    @property = Property.new(property_params)
    if @property.save
      redirect_to properties_path, alert: "Created Successfully"
    else
      redirect_to new_property_path
    end
  end

  def city
    @city = params[:city].downcase.capitalize!
    @properties = Property.joins(:address).where(:addresses => {:city => @city})
    if @properties.empty?
      @errorcode = 'notfound'
      render :city_error
    else
      render :city
    end
  end

  def cities
    @addresses = Address.select(:city).distinct
    render :cities
  end

  private

  def property_params
    params.require(:property).permit(:description, :photo, address_attributes: [:address_first, :address_second, :city, :postal_code])
  end

end
