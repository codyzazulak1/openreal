class PropertiesController < ApplicationController

  def index
    unapproved_listings = Status.where(name: ['Pending Approval', 'Unapproved'])
    if params[:city]
      @city = params[:city].capitalize
      @center = city_center(@city)
      @properties = Property.where.not(status: unapproved_listings).includes(:address, :photos).within(@city)
    else
      @properties = Property.includes(:address, :photos).for_sale.where.not(status: unapproved_listings).created_desc
      @sold = Property.except_contact_form_submission.where('list_price_cents = ?', 0).count
      @center = {lat: 49.2400769, lng: -123.0282093}
    end
     #meta tags
    set_meta_tags title: "Online Platform for Selling Properties by Home Owners | Listings ",
      description: "Canada’s 1st online platform for home owners to sell their property fast, worry free, with / without real estate agent. Sell your home for cash quick. Listings"
    @cities = Property.cities
    @properties_paged = @properties.paginate(:page => params[:page], :per_page => 10)
    respond_to do |format|
      format.html
      format.js
      format.json do
        render json: {properties: @properties.as_json(:include => [:address, :photos]), center: @center}
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
    unapproved_listings = Status.where(name: ['Pending Approval', 'Unapproved'])
    @properties = Property.includes(:address, :photos).for_sale.where.not(status: unapproved_listings)

    cookies[:sort_params] = {value: params["sort"]}   

   

    if params["min-price"]
      @properties = @properties.includes(:address, :photos).where("properties.list_price_cents >= ?", params["min-price"].to_i)
    end
    if params["show"]
      @properties = Property.includes(:address, :photos).where.not(status: unapproved_listings).all.except_contact_form_submission
    end

    if params["max-price"] && params["max-price"] != ''
      @properties = @properties.includes(:address, :photos).where("list_price_cents <= ?", params["max-price"].to_i)
    end
    if params["bed"] && params["bed"] != ''
      @properties = @properties.includes(:address, :photos).where("bedrooms >= ?", params["bed"].to_i)
    end
    if params["bath"] && params["bath"] != ''
      @properties = @properties.includes(:address, :photos).where("bathrooms >= ?", params["bath"].to_i)
    end
    if params["building"] && params["building"] != ''
      case params["building"]
      when "0"
        @properties.includes(:address, :photos)
      when "1"
        @properties = @properties.includes(:address, :photos).where("dwelling_class LIKE ?", 
          ("%ouse%" || "%ingle%"))
      when "2"
        @properties = @properties.includes(:address, :photos).where("dwelling_class LIKE ?", 
          ("%ownhouse%" || "%town%"))
      when "3"
        @properties = @properties.includes(:address, :photos).where("dwelling_class LIKE ?", 
          ("%partment%" || "%ondo%"))
      end
    end

    if params["storeys"] && params["storeys"] != ''
      @properties = @properties.includes(:address, :photos).where("stories >= ?", params["storeys"].to_i)
    end
    if params["min-floor"] && params["min-floor"] != ''
      @properties = @properties.includes(:address, :photos).where("floor_area >= ?", params["min-floor"].to_i)
    end
    if params["min-lot"] && params["min-lot"] != ''
      @properties = @properties.includes(:address, :photos).where("(lot_length * lot_width) >= ?", params["min-lot"].to_i)
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

    if params["sort"] && params["sort"] != ''
      
      case params["sort"]
      when "high"
        @properties = @properties.includes(:address, :photos).price_desc

      when "low"
        @properties = @properties.includes(:address, :photos).price_asc

      when "newer"
        @properties = @properties.includes(:address, :photos).created_desc
      
      end

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
	
    session[:property] 	||= {}
    session[:address_params] 		||= {}
    session[:property_upgrades] ||= {}
    # session[:params] = session[:params].nil? ? {} : params.merge(session[:params])
    @property 						 = Property.new
    @address 							 = Address.new(session[:address_params].merge({property: @property}))
    @address 				 		 ||= Address.new(property: @property)
    @contact 					 		 = ContactForm.new
	 	@property_upgrades 		 = 	@property.property_upgrades.build
    @property.current_step = session[:property_step]
		
		#for upgrades
		@pool 	= upgrade_pool
		@other 	= upgrade_other
		@kc 		= upgrade_kitchen_condition
		@kco 		= upgrade_kitchen_countertops
		@ka			= upgrade_kitchen_appliances
		@ke 		= upgrade_kitchen_extras
		@bathc 	= upgrade_bath_condition
		@bathe 	= upgrade_bath_extras
		@hyflo 	= upgrade_hy_flo_cd
		@hyliv 	= upgrade_hy_liv_ar
		@hyp		= upgrade_hy_paint
		@hyback = upgrade_hy_backyard

	end

  def show
    @property = Property.find(params[:id])
    
    if (Property.all.count != 0 && @property)
      unapproved_listings = Status.where(name: ['Pending Approval', 'Unapproved'])
      @properties = Property.where.not(status: unapproved_listings).all
      @similar_properties = Property.where.not(status: unapproved_listings).similar_listings(@property, 3)
      @inquiry = ContactForm.new

      if @property.agent_id
        @agent = Agent.find(@property.agent_id)
      end

      set_meta_tags title: "#{@property.address.address_first}, #{@property.address.city}, BC",
      description: "#{@property.description}"

      if !(@property.list_price_cents == 0)
        if !(@property.dwelling_class.nil?)
          if (@property.dwelling_class.downcase.include? "house") || (@property.dwelling_class.include? "single")
            @dwelling_type = "House"
          end
          if (@property.dwelling_class.downcase.include? "apartment") || (@property.dwelling_class.include? "condo")
            @dwelling_type = "Apartment"
          end
          if (@property.dwelling_class.downcase.include? "town") || (@property.dwelling_class.downcase.include? "townhouse")
            @dwelling_type = "Townhouse"
          end
        else
          nil
        end

        respond_to do |format|
          format.html
          format.js
          format.json do
            render json: @property.to_json(include: [:address])
          end
        end
      else
        redirect_to '/listings'
      end

    else
      redirect_to '/listings'
      flash[:notice] = "The listing you're trying to access doesn't exist or is no longer available."
    end

  end

  def create
   # session[:params] = session[:params].nil? ? params : params.merge(session[:params])
    session[:property] 				||= property_params unless params[:property].nil?
    session[:property] 					= session[:property].merge(property_params) unless params[:property].nil?
    session[:address_params]		= address_params if !params[:property].nil? && !params[:property][:address_attributes].nil?
    session[:contact] 					= contact_params if !params[:property].nil? && !params[:property][:contact_form_attributes].nil?
		
		session[:property].delete("property_upgrades_attributes")
		
		@property = Property.new(session[:property])
		@property.list_price_cents = 0
    @address ||= Address.new(session[:address_params])
    @contact = ContactForm.new(session[:contact])
    @property.current_step = session[:property_step]
		@property_upgrades = @property.property_upgrades.build
    @contact.property = @property
    @contact.status = Status.find_by(name: "Unappraised").name 
    @contact.sub_type = "Property Submission"
  	
		#for upgrades
			@pool 	= upgrade_pool
			@other 	= upgrade_other
			@kc 		= upgrade_kitchen_condition
			@kco 		= upgrade_kitchen_countertops
			@ka			= upgrade_kitchen_appliances
			@ke 		= upgrade_kitchen_extras
			@bathc 	= upgrade_bath_condition
			@bathe 	= upgrade_bath_extras
			@hyflo 	= upgrade_hy_flo_cd
			@hyliv 	= upgrade_hy_liv_ar
			@hyp		= upgrade_hy_paint
			@hyback = upgrade_hy_backyard

		#upgrades sessions for sections
		unless params[:property].nil? || params[:property][:property_upgrades_attributes].nil?	
			session[:features] = params[:property][:property_upgrades_attributes][:upgrade_id] unless params[:property][:property_upgrades_attributes][:upgrade_id].nil?
		end
		session[:kitch] = params[:kitchen] unless params[:kitchen].nil?
		session[:bath] = params[:bath]	unless params[:bath].nil?
		session[:hy] = params[:hy] unless params[:hy].nil?
	
    # if @property.valid?
    if params

      if params[:back_button]

        @property.previous_step

      elsif @property.last_step?
        
				if @property.all_valid?
				
					if @property.stories.is_a? String
						if @property.stories.include? ('+')
							@property.stories = @property.stories.split('+')[0].to_i
						end
					end
					
					if @property.bedrooms.is_a? String
						if @property.bedrooms.include? ('+')
								@property.bedrooms = @property.bedrooms.split('+')[0].to_i
						end
					end

					if @property.bathrooms.is_a? String
						if @property.bathrooms.include? ("+")
								@property.bathrooms = @property.bathrooms.split('+')[0].to_i
						end
					end

					if @property.save

								session[:features].each { |x|
									@property.property_upgrades.create(property_id: @property.id, upgrade_id: x.to_i) unless x == nil
								}	
								session[:kitch].values.flatten.each { |k|
									@property.property_upgrades.create(property_id: @property.id, upgrade_id: k.to_i) unless k == nil
								}
								session[:bath].values.flatten.each { |b| 
									@property.property_upgrades.create(property_id: @property.id, upgrade_id: b.to_i) unless b == nil
								}

								session[:hy].values.each { |h|
									@property.property_upgrades.create(property_id: @property.id, upgrade_id: h.to_i) unless h == nil
								}	

						@contact.save

					end

        end

      else

        @property.next_step

      end

      session[:property_step] = @property.current_step

    end

    if @property.new_record?
      render 'new'
    else
      session[:property_step] = session[:property] = session[:address_params] = session[:property_upgrades] = session[:kitch] = session[:bath] = session[:hy] = session[:features] = nil 
      render "confirmed"
    end
  end

 
  private

  def city_center(city)
    uri = "https://maps.googleapis.com/maps/api/geocode/json?address=#{city}&region=ca&key=#{ENV['GEOCODER']}"
    address = JSON.parse(open(uri).read)["results"]
    geo = address[0]["geometry"]
    center = geo["location"]
  end

  def property_params
    params.require(:property).permit(:description, :floor_area, :stories,:list_price_cents, :bedrooms, :bathrooms, :upgrade_cost, :agent_id, photos_attributes: [:picture], address_attributes: [:address_first, :address_second, :city, :postal_code, :latitude, :longitude], contact_form_attributes: [:name, :email, :phone, :notes, :timeframe], property_upgrades_attributes: [:property_id, :upgrade_id, :id])
  end

  def address_params
    params.require(:property).require(:address_attributes).permit(:address_first, :address_second, :city, :postal_code, :latitude, :longitude)
  end

  def contact_params
    params.require(:property).require(:contact_form_attributes).permit(:name, :email, :phone, :notes, :timeframe)
  end
	
	def property_upgrade_params
		params.require(:property).require(:property_upgrades_attributes).permit(:property_id, :upgrade_id)
	end

  def setup_show_propid
    @property ||= Property.find(params[:id])
    if @property.status_id == 4
      redirect_to '/listings'
      flash[:notice] = "The listing you're trying to access doesn't exist or is no longer available"
    else
      return @property
    end

  end

	def upgrade_pool
		return  Upgrade.where(section: 'pool').all
	end

	def upgrade_other				
		return  Upgrade.where(section: 'other').all
	end

	def upgrade_kitchen_condition
		return  Upgrade.where(section: 'kitchen', feature: 'condition').all
	end	
	
	def upgrade_kitchen_countertops
		return  Upgrade.where(section: 'kitchen', feature: 'countertops').all
	end

	def	upgrade_kitchen_appliances
		return  Upgrade.where(section: 'kitchen', feature: 'appliances').all
	end

	def	upgrade_kitchen_extras
		return  Upgrade.where(section: 'kitchen', feature: 'extra_features').all
	end
	
	def	upgrade_bath_condition
		return Upgrade.where(section: 'bathroom', feature: 'condition').all
	end

	def	upgrade_bath_extras
		return  Upgrade.where(section: 'bathroom', feature: 'extra_features').all
	end

	def	upgrade_hy_flo_cd
		return  Upgrade.where(section: 'home_yard', feature: 'flooring condition').all
	end

	def	upgrade_hy_liv_ar
		return  Upgrade.where(section: 'home_yard', feature: 'living area flooring kind').all
	end

	def upgrade_hy_paint
		return  Upgrade.where(section: 'home_yard', feature: 'paint condition').all
	end

	def upgrade_hy_backyard
		return  Upgrade.where(section: 'home_yard', feature: 'back yard condition').all
	end


end
