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

  def listings_show
    if resource_class == Agent && agent_signed_in?
      @agent = current_agent
      @property = Property.find(params[:id])

      @address = @property.address
      @property_attributes = Property.column_names - ["id", "created_at", "updated_at"]
     @address_attributes = Address.column_names - ["id", "created_at", "updated_at", "property_id", "latitude", "longitude"]
      flash[:notice] = 'More features coming soon.'
      render 'agents/listing_show'
    else
      unauthorized_access
    end
  end

  def listings_edit
    if resource_class == Agent && agent_signed_in?
      @agent = current_agent
      @property = Property.find(params[:id])

    else
      unauthorized_access
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

  def profile_picture
    if resource_class == Agent && agent_signed_in?
      @agent = current_agent
      if (@agent != nil)
        @agent.profile_picture = params['agent']['profile_picture']
        @agent.save!
        redirect_to agent_dashboard_path
      end
    end
  end

  protected

  def after_sign_up_path_for(resource)

    agent = current_agent

    # agent.profile_picture = "#{session[:temp_agent_info]["portrait"]}"
    # agent.save!

    session[:temp_agent_info]["listings"].each do |listing|
      property = Property.new(
        list_price_cents: listing["list_price_cents"],
        description: listing["description"],
        agent_id: agent.id,
        bedrooms: listing["bedrooms"] || nil,
        bathrooms: listing["bathrooms"] || nil,
        floor_area: listing["floor_area"] || nil,
        year_built: listing["year_built"] || nil,
        status_id: 4
      )

      if property.save
        # puts "Saved Property"
      else
        # puts "Could not save Property"
      end
      
      address = Address.new(
        address_first: listing["address"]["address_first"],
        address_second: listing["address"]["address_second"],
        street: listing["address"]["street"],
        city: listing["address"]["city"],
        postal_code: listing["address"]["postal_code"],
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

end
