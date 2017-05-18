class RegistrationsController < Devise::RegistrationsController

  require_relative '../../lib/agent_finder.rb'
  include AgentFinder

  def agent_setup

    if resource_class == Agent
      @agent = Agent.new(sign_up_params)
      session[:agent_params] = {
        first_name: @agent.first_name,
        last_name: @agent.last_name,
        company_name: @agent.company_name,
      }

      session.delete(:temp_agent_info)
      session[:temp_agent_info] = AgentFinder.searchByName("#{session[:agent_params][:first_name]}","#{session[:agent_params][:last_name]}", session[:agent_params][:company_name]) 

      redirect_to new_agent_registration_path
    end
  end

  def new
    @agent = Agent.new(session[:agent_params])
  
    # No access to create a new admin
    if resource_class == Admin
      redirect_to new_admin_session_path
    end
  end

  def dashboard
    if resource_class == Agent && agent_signed_in?
      @agent = current_agent
      @photo = @agent.profile_picture
      render 'agents/dashboard'
    else
      unauthorized_access
    end
  end

  def listings_index
    if resource_class == Agent && agent_signed_in?
      @agent = current_agent
      @properties = Property.where(agent_id: @agent.id).order(created_at: :desc)
     

      agent_submitted = Status.where(category: 'Agent Submitted')

      statuses_name = [].push(agent_submitted.map{|sn| sn.name}).flatten

      if statuses_name.include?(params[:filter])
        @properties = Property.where(agent_id: @agent.id).joins(:status).where(statuses: {name: params[:filter], category: 'Agent Submitted'})
      else
        @properties = Property.where(agent_id: @agent.id).joins(:status).where(statuses: {category: 'Agent Submitted'}).order(created_at: :desc)
      end

     @properties_paged = @properties.paginate(:page => params[:page], :per_page => 10)
      render 'agents/listings'

    else
      unauthorized_access
    end
  end

  def services
    render 'agents/services'
  end

  def listings_show
    if resource_class == Agent && agent_signed_in?
      @agent = current_agent
      @property = Property.find(params[:id])

      @address = @property.address
      @property_attributes = Property.column_names - ["id", "created_at", "updated_at"]
      @address_attributes = Address.column_names - ["id", "created_at", "updated_at", "property_id", "latitude", "longitude"]
    
      render 'agents/listing_show'
    else
      unauthorized_access
    end
  end

  def listings_edit
    if resource_class == Agent && agent_signed_in?
      
      @agent = current_agent
      @property = Property.find(params[:id])
      @property_attributes = Property.column_names - ["id", "created_at", "updated_at"]
      @address_attributes = Address.column_names - ["id", "created_at", "updated_at", "property_id", "latitude", "longitude"]

      @photos_build = @property.photos.build

      @photos = @property.photos
      render 'agents/listing_edit'
    else
      unauthorized_access
    end
  end

  def listings_update

     if resource_class == Agent && agent_signed_in?
      @agent = current_agent
      @property = Property.find(params[:id])
      @address = @property.address

      if @property.update!(property_params)
        if !(params[:photos].blank?)
         params[:photos]['picture'].each { |p|
          @photos = @property.photos.create!(picture: p, property_id: @property.id) 
         }
        end

        redirect_to agent_listings_path
        flash[:notice] = "Successfully updated #{@address.address_first} #{@address.address_second} #{@address.city}"
      end
     end

  end

  def delete_agprop
    @agent = current_agent
    if @agent 
      @property = Property.find(params[:id])
      @property.destroy
      redirect_to agent_dashboard_path
      flash[:success] = "Successfully deleted property #{@property.address_first @property.address_second}"
    else
      unauthorized_access
    end
  end

  def photo_delete
    @photo = Photo.find(params[:id])
    @property = Property.find(params[:property_id])

    if @property.featured_photo && @photo.picture.large.url == @property.featured_photo
      @property.featured_photo = ""
      @photo.destroy
      @property.save   
    else
      @photo.destroy
    end
   
    respond_to do |format|
      format.js { render template: 'dashboard/properties/destroy.js.erb', layout: false}
    end

  end

  def featured_photo
    @property = Property.find(params[:id])
    @photos = @property.photos
    if @property && (@property.featured_photo.blank? || @property.featured_photo.nil?)
      @property.update(featured_photo: params[:featured_photo])

    else
      @property.featured_photo = nil
      @property.update(featured_photo: params[:featured_photo])
    end

    respond_to do |format|
      format.html {redirect_to agent_listing_edit(@property)}
      format.js {render template: 'agents/featured_photo_propagents.js.erb'}
    end
  end

  def profile_picture
    if resource_class == Agent && agent_signed_in?
      @agent = current_agent
      if (@agent != nil)
        @agent.update(profile_picture: params['agent']['profile_picture'])
        redirect_to agent_dashboard_path

      end
    end
  end

  protected

  def after_sign_up_path_for(resource)

    agent = current_agent

     # byebug
    agent.remote_profile_picture_url = session[:temp_agent_info]['portrait']
    agent.save

    session[:temp_agent_info]["listings"].each do |listing|
      property = Property.new(
        list_price_cents: listing["property"]["list_price_cents"],
        description: listing["property"]["description"],
        agent_id: agent.id,
        bedrooms: listing["property"]["bedrooms"] || nil,
        bathrooms: listing["property"]["bathrooms"] || nil,
        floor_area: listing["property"]["floor_area"] || nil,
        year_built: listing["property"]["year_built"] || nil,
        status: Status.find_by(name: "Pending Approval", category: "Agent Submitted")
      )
      byebug
      # puts "################################################################################################################## \n #{listing['pictures']}"

      if property.save
        # puts "Saved Property"
        photo_arr = listing["pictures"]
        byebug
        photo_arr.each { |src|
          u = property.photos.build
          u.remote_picture_url = src
          if u.save
            puts "###################### Saved Photo"
          else
            puts "###################### Photo Upload Failed"
          end
        }

      else
        # puts "Could not save Property"
      end
      
      address = Address.new(
        address_first: listing["property"]["address"]["address_first"],
        address_second: listing["property"]["address"]["address_second"],
        street: listing["property"]["address"]["street"],
        city: listing["property"]["address"]["city"],
        postal_code: listing["property"]["address"]["postal_code"],
        property_id: property.id
      )
      
      if address.save
        # puts 'Saved address'
      else
        # puts 'Could not save Address'
      end

    end

    session.delete(:temp_agent_info)

    return agent_dashboard_path
  end

  # def after_sign_in_path_for(resource)
  #   agents_dashboard_path
  # end

  # def after_update_path_for(resource)
  #   signed_in_root_path(resource)
  # end

  private

    def unauthorized_access
      redirect_to root_path
      flash[:error] = "Unauthorized access. Please Sign up or Login."
    end

    def sign_up_params
      if resource_class == Admin
        params.require(:admin).permit(:first_name, :last_name, :email, :password, :password_confirmation)
      elsif resource_class == Agent
        params.require(:agent).permit(:first_name, :last_name, :email, :password, :password_confirmation, :company_name, :profile_picture).except!(:agent_id)
      elsif resource_class == Customer
        params.require(:customer).permit(:first_name, :last_name, :email, :password, :password_confirmation)
      end
    end

    def account_update_params
      if resource_class == Admin
        params.require(:admin).permit(:first_name, :last_name, :email, :password, :password_confirmation)
      elsif resource_class == Agent

        params.require(:agent).permit(:first_name, :last_name, :email, :password, :password_confirmation, :company_name, :current_password, :profile_picture)

      elsif resource_class == Customer
        params.require(:customer).permit(:first_name, :last_name, :email, :password, :password_confirmation)
      end
    end


    def property_params
      if resource_class == Agent
        params.require(:property).permit(:id,
        :description, :floor_area, :list_price_cents,
        :dwelling_class,:building_type,:property_type,
        :title_to_land,:year_built,:fireplaces,
        :number_of_floors, :stories, :bedrooms,
        :bathrooms,:lot_length,:lot_width, :pid,
        :seller_info, :sellers_interest, :architecture_style,
        :matterurl, :featured_photo,
        photos_attributes: [
          :picture, :property_id
        ],
        address_attributes:
        [
          :address_first, :address_second, :street,
          :city, :postal_code, :property_id, :latitude, :longitude
        ]
        )
      end
    end



end
