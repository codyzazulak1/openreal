class Dashboard::PropertiesController < ApplicationController

  def index
    @properties = Property.all.order(created_at: :desc)
    @statuses = Property.status_list

    if params[:filter] && @statuses.key?(params[:filter])
      @properties = @properties.where(status: params[:filter])
    end

    @properties_paged = @properties.paginate(:page => params[:page], :per_page => 10)
  end

  def show
    @property = Property.find(params[:id])
    @property_attributes = Property.column_names - ["id", "created_at", "updated_at"]
    @address_attributes = Address.column_names - ["id", "created_at", "updated_at", "property_id", "latitude", "longitude"]
  end

  def edit
    @property = Property.find(params[:id])
    @address = @property.address
    @property_attributes = Property.column_names - ["id", "created_at", "updated_at"]
    @address_attributes = Address.column_names - ["id", "created_at", "updated_at", "property_id", "latitude", "longitude"]
  end

  def update
    @property = Property.find(params[:id])
    @address = @property.address

    if @property.update_attributes(property_params)
      redirect_to dashboard_property_path(@property)
    end
  end

  def status
    property = Property.find(params[:property_id])
    property.update(status: params[:status])

    respond_to do |format|
      format.json do
       render json: property.as_json(only: [:status])
     end
    end
  end

  def new

  end

  def create

  end

  private

  def property_params
    params.require(:property).permit(:description, :floor_area, :stories, :bedrooms, :bathrooms, photos_attributes: [:picture], address_attributes: [:address_first, :address_second, :city, :postal_code], contact_form_attributes: [:name, :email, :phone, :notes])
  end

  def address_params
    params.require(:property).require(:address_attributes).permit(:address_first, :address_second, :city, :postal_code)
  end

end
