class PropertiesController < ApplicationController

  def index
    @properties = Property.all
    respond_to do |format|
      format.html
      format.json do
        render json: @properties.to_json(include: [:address])
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
    # session[:params] = session[:params].nil? ? {} : params.merge(session[:params])

    @property = Property.new
    @address = Address.new(session[:address_params].merge({property: @property}))
    @address ||= Address.new(property: @property)
    @contact = ContactForm.new
    @property.current_step = session[:property_step]
    @photo = @property.photos.build
  end

  def show
    if Property.all.count != 0
      @property = Property.find(params[:id])
    else
      redirect_to :index
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

    @property = Property.new(session[:property])
    @address = Address.new(session[:address])
    @contact = ContactForm.new(session[:contact])
    @property.current_step = session[:property_step]
    @photo = @property.photos.build

    # if @property.valid?
    if params
      if params[:back_button]
        @property.previous_step
      elsif @property.last_step?
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
      # flash[:notice] = "property saved!"
      render "confirmed"
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

  def favorite
    @property = Property.find(params[:property_id])
    @customer = current_customer
    @favorite = Favorite.new(property: @property, customer: @customer)

    if @favorite.save
      redirect_to @property
    end
  end

  def unfavorite
    @property = Property.find(params[:property_id])
    @customer = current_customer
    @favorite = Favorite.find_by(property: @property, customer: @customer)

    @favorite.destroy

    redirect_to @property

  end

  private

  def property_params
    params.require(:property).permit(:description, :floor_area, :stories, :bedrooms, :bathrooms, photos_attributes: [:picture], address_attributes: [:address_first, :address_second, :city, :postal_code], contact_form_attributes: [:name, :email, :phone, :notes])
  end

  def address_params
    params.require(:property).require(:address_attributes).permit(:address_first, :address_second, :city, :postal_code)
  end

  def contact_params
    params.require(:property).require(:contact_form_attributes).permit(:name, :email, :phone, :notes)
  end

end
