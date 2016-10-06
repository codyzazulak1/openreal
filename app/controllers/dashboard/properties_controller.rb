class Dashboard::PropertiesController < ApplicationController

  before_action :authenticate_admin!

  def index
    @properties = Property.all.order(created_at: :desc)

    @customer_submitted = Status.where(category: "Customer Submitted")
    @agent_submitted = Status.where(category: "Agent Submitted")
    @owned = Status.where(category: "Owned Properties")
    categories = ["Customer Submitted", "Agent Submitted", "Owned Properties"]
    names = @customer_submitted.map{|cs| cs.name}
            .push(@agent_submitted
              .map{|as| as.name})
            .push(@owned
              .map{|o| o.name})
            .flatten!

    if categories.include?(params[:filter])
      @properties = Property.joins(:status).where(statuses: {category: params[:filter]})
    elsif names.include?(params[:filter])
      @properties = Property.joins(:status).where(statuses: {name: params[:filter]})
    else
      @properties = Property.all.order(created_at: :desc)
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
    property.update(status_id: Status.find_by(name: params["status"]).id)

    respond_to do |format|
      format.json do
       render json: property.as_json(only: [:status])
     end
    end
  end

  def new
    @property = Property.new
    @address = Address.new(property: @property)
    @property_attributes = Property.column_names - ["id", "created_at", "updated_at"]
    @address_attributes = Address.column_names - ["id", "created_at", "updated_at", "property_id", "latitude", "longitude"]
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
