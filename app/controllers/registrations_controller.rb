class RegistrationsController < Devise::RegistrationsController

  require 'AgentFinder'

  def agent_setup
    if resource_class == Agent
      @agent = Agent.new(sign_up_params)
      session[:agent_params] = {
        first_name: @agent.first_name,
        last_name: @agent.last_name,
        company_name: @agent.company_name
      }
      #code to retrieve email and photo if Sutton agent

      redirect_to new_agent_registration_path
    end
  end

  def new
    @agent = Agent.new(session[:agent_params])
    # session.delete(:agent_params)

    # No access to create a new admin
    if resource_class == Admin
      redirect_to new_admin_session_path
    end
  end

  def dashboard
    agent = Agent.find(current_agent)
    @info = AgentFinder.searchByName(agent.full_name, agent.company_name)

    render 'agents/dashboard'
  end

  protected

  def after_sign_up_path_for(resource)
    agents_dashboard_path
  end

  private

    def sign_up_params
      if resource_class == Admin
        params.require(:admin).permit(:first_name, :last_name, :email, :password, :password_confirmation)
      elsif resource_class == Agent
        params.require(:agent).permit(:first_name, :last_name, :email, :password, :password_confirmation, :company_name).except!(:agent_id)
      elsif resource_class == Customer
        params.require(:customer).permit(:first_name, :last_name, :email, :password, :password_confirmation)
      end
    end

    def account_update_params
      if resource_class == Admin
        params.require(:admin).permit(:first_name, :last_name, :email, :password, :password_confirmation)
      elsif resource_class == Agent
        params.require(:agent).permit(:first_name, :last_name, :email, :password, :password_confirmation, :company_name)
      elsif resource_class == Customer
        params.require(:customer).permit(:first_name, :last_name, :email, :password, :password_confirmation)
      end
    end

end
