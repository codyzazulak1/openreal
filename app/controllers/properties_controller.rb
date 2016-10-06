class PropertiesController < ApplicationController

  def index
    if params[:city]
      @city = params[:city].capitalize
      @center = city_center(@city)
      @properties = Property.within(@city)
    else
      @properties = Property.all.order('created_at DESC')
      @center = {lat: 49.2447, lng: -123.1359}
    end
    @cities = Property.cities
    @properties_paged = @properties.paginate(:page => params[:page], :per_page => 10)
    respond_to do |format|
      format.html
      format.js
      format.json do
        render json: {properties: @properties.as_json(:include => :address), center: @center}
      end
    end
  end

  def edit
    @property = Property.find(params[:id])
    @address = @property.address

    if @property.update_attributes(property_params)
      redirect_to dashboard_property_path(@property)
    end

  end

  def update
    @property = Property.find(params[:id])
    @address = @property.address

    if @property.update_attributes(property_params)
      redirect_to dashboard_property_path(@property)
    end

  end

  def filter
    @properties = Property.all
      .order('list_price_cents ASC')

    if params["min-price"]
      @properties = @properties.where("list_price_cents >= ?", params["min-price"].to_i)
    end
    if params["max-price"] && params["max-price"] != ''
      @properties = @properties.where("list_price_cents <= ?", params["max-price"].to_i)
    end
    if params["bed"]
      @properties = @properties.where("bedrooms >= ?", params["bed"].to_i)
    end
    if params["bath"]
      @properties = @properties.where("bathrooms >= ?", params["bath"].to_i)
    end
    if params["storeys"]
      @properties = @properties.where("stories >= ?", params["storeys"].to_i)
    end
    if params["min-floor"] && params["min-floor"] != ''
      @properties = @properties.where("floor_area >= ?", params["min-floor"].to_i)
    end
    if params["min-lot"] && params["min-floor"] != ''
      @properties = @properties.where("(lot_length * lot_width) >= ?", params["min-lot"].to_i)
    end
    if params["city"] && params["city"] != ''
      @properties = @properties
        .joins(:address)
        .where("LOWER(addresses.city) = LOWER(?)", params["city"])
    end
    if params["bound-east"] && params["bound-west"] && params["bound-north"] && params["bound-south"] && !(params["bound-east"] == "" || params["bound-west"] == "" || params["bound-north"] == "" || params["bound-south"] == "")
      @properties = @properties
        .joins(:address)
        .where("addresses.latitude BETWEEN ? AND ?", params["bound-south"].to_f, params["bound-north"].to_f)
        .where("addresses.longitude BETWEEN ? AND ?", params["bound-west"].to_f, params["bound-east"].to_f)
    end

    @properties_paged = @properties.paginate(:page => params[:page], :per_page => 10)
    respond_to do |format|
      format.html
      format.js do
        unless params["page"]
          render 'filter'
        else
          render 'filter2'
        end
      end
    end
  end

  def sell
    session[:property_step] = nil
    session[:address_params] = {
      address_first: params['addressFirst'],
      address_second: params['addressSecond'],
      city: params['addressCity'],
      postal_code: params['addressPostal'],
      latitude: params['addressLat'],
      longitude: params['addressLng']
    }
    redirect_to new_property_path
  end

  def new

    session[:property_params] ||= {}
    session[:address_params] ||= {}
    # session[:property_upgrades_params] ||= {}
    # session[:params] = session[:params].nil? ? {} : params.merge(session[:params])

    @property = Property.new
    @address = Address.new(session[:address_params].merge({property: @property}))
    @address ||= Address.new(property: @property)
    @contact = ContactForm.new

 
    @property_upgrades = @property.property_upgrades.build

    @property.current_step = session[:property_step]
    @photo = @property.photos.build

  def show
    if Property.all.count != 0

      @property = Property.find(params[:id])
      @similar_properties = Property.similar_listings(@property, 3)

      if customer_signed_in?
        @favorite = Favorite.find_by(property: @property, customer: current_customer)
      end

      respond_to do |format|
        format.html
        format.js
        format.json do
          render json: @property.to_json(include: [:address])
        end
      end
    end
  end

    if customer_signed_in?
      if current_customer.favorites.where(property: @property).exists?
        @has_favorite = true
      else
        @has_favorite = false
      end
    end

  end

  def create
    # byebug
    # session[:params] = session[:params].nil? ? params : params.merge(session[:params])
    session[:property] ||= property_params unless params[:property].nil?
    session[:property] = session[:property].merge(property_params) unless params[:property].nil?
    session[:address] = address_params if !params[:property].nil? && !params[:property][:address_attributes].nil?
    session[:contact] = contact_params if !params[:property].nil? && !params[:property][:contact_form_attributes].nil?

    session[:property_upgrades] = property_upgrade_params if !params[:property].nil? && !params[:property][:property_upgrades].nil?


    @property = Property.new(session[:property])
    @address = Address.new(session[:address])
    @contact = ContactForm.new(session[:contact])

   
    @property_upgrade = @property.property_upgrades.new(session[:property_upgrades])

    @property.current_step = session[:property_step]
    @photo = @property.photos.build
    

    # if @property.valid?
    if params
      if params[:back_button]
        @property.previous_step
      elsif @property.last_step?
        @property.list_price_cents = 0
        @property.save if @property.all_valid?
      else
        @property.next_step
      end
      session[:property_step] = @property.current_step
    end

    if @property.new_record?
      render 'new'
    else
      session[:property_step] = session[:property] = session[:address] = nil
      render "confirmed"
    end
  end

  def destroy
    @property = Property.find(params[:id])
    @property.destroy
    redirect_to dashboard_properties_path
  end

  # def all_valid?
  #   steps.all? do |step|
  #     self.current_step = step
  #     valid?
  #   end
  # end


  private

  def city_center(city)
    uri = "https://maps.googleapis.com/maps/api/geocode/json?address=#{city}&region=ca&key=#{ENV['GEOCODER']}"
    address = JSON.parse(open(uri).read)["results"]
    geo = address[0]["geometry"]
    center = geo["location"]
  end

  def property_params

    params.require(:property).permit(:description, :floor_area, :stories, :bedrooms, :bathrooms, photos_attributes: [:picture], address_attributes: [:address_first, :address_second, :city, :postal_code], contact_form_attributes: [:name, :email, :phone, :notes, :timeframe],property_upgrades_attributes: [:property_id, :upgrade_id, upgrades: [:id, :name]])
  end

  # def property_upgrade_params
  #   params.require(:property).require(:property_upgrades_attributes).permit(:property_id, :upgrade_id,:id)   
  # end

  # def upgrade_params
  #   params.require(:property).require(:upgrades_attributes).permit(:id, :name)
  # end

  def address_params
    params.require(:property).require(:address_attributes).permit(:address_first, :address_second, :city, :postal_code)
  end

  def contact_params
    params.require(:property).require(:contact_form_attributes).permit(:name, :email, :phone, :notes, :timeframe)
  end
end
