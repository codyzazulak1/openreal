class Dashboard::PropertiesController < ApplicationController

  before_action :authenticate_admin!

  def index
    @properties = Property.all.order(created_at: :desc)

    @customer_submitted = Status.where(category: "Customer Submitted")
    @agent_submitted = Status.where(category: "Agent Submitted")
    @owned = Status.where(category: "Owned Properties")
    categories = ["Customer Submitted", "Agent Submitted", "Owned Properties"]
    names = [].push(@customer_submitted
              .map{|cs| cs.name})
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
      redirect_to dashboard_properties_path(@property)
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
    @property_attributes = Property.column_names - ["id", "created_at", "updated_at", "status_id"]
    @address_attributes = Address.column_names - ["id", "created_at", "updated_at", "property_id", "latitude", "longitude"]
  end

  def create
    @property = Property.new(property_params)
    @address = Address.new
    # @address.property = @property[:id]

    @property_attributes = Property.column_names - ["id", "created_at", "updated_at", "status_id"]
    @address_attributes = Address.column_names - ["id", "created_at", "updated_at", "property_id", "latitude", "longitude"]

    if @property.save
      flash[:success] = "Property has been added!"
      redirect_to dashboard_properties_path
    else
      flash[:error] = "Something went wrong, please fill again."
      render 'new'
    end
  end

  def destroy
    @property = Property.find(params[:id])
    @property.destroy
    redirect_to dashboard_properties_path
  end

  private

  def property_params
    params.require(:property).permit(:description, :floor_area, :list_price_cents,:dwelling_class,:building_type,:property_type,:title_to_land,:year_built,:fireplaces,:number_of_floors, :stories, :bedrooms, :bathrooms,:lot_length,:lot_width, photos_attributes: [:picture], address_attributes: [:address_first, :address_second, :city, :postal_code], contact_form_attributes: [:name, :email, :phone, :notes])
  end

  def address_params
    params.require(:property).require(:address_attributes).permit(:address_first, :address_second, :city, :postal_code)
  end

end
