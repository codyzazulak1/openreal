class PropertiesController < ApplicationController

  def index
    @properties = Property.all
  end

  def new
    # session[:property_params] ||= {}
    # session[:address_params] ||= {}
    # session[:params] = session[:params].nil? ? {} : params.merge(session[:params])

    @property = Property.new
    @address = Address.new
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
  end

  def create
    # byebug
    # session[:params] = session[:params].nil? ? params : params.merge(session[:params])
    session[:property] ||= property_params unless params[:property].nil?
    session[:property] = session[:property].merge(property_params) unless params[:property].nil?
    session[:address] = address_params if !params[:property].nil? && !params[:property][:address_attributes].nil?
    session[:contact] = contact_params if !params[:property].nil? && !params[:property][:contact].nil?

    @property = Property.new(session[:property])
    @address = Address.new(session[:address])
    @contact = ContactForm.new(session[:contact])
    @property.current_step = session[:property_step]
    @photo = @property.photos.build
    byebug

    if @property.valid?
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
      render "new"
    else
      session[:property_step] = session[:property] = session[:address] = nil
      flash[:notice] = "property saved!"
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

  private

  def property_params
    params.require(:property).permit(:description, :floor_area, :stories, :bedrooms, :bathrooms, photos_attributes: [:picture], address_attributes: [:address_first, :address_second, :city, :postal_code])
  end

  def address_params
    params.require(:property).require(:address_attributes).permit(:address_first, :address_second, :city, :postal_code)
  end

  def contact_params
    params.require(:property).require(:contact).permit(:name, :email, :phone, :notes)
  end

end
