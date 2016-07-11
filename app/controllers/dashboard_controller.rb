class DashboardController < ApplicationController

  def get_dash
    if admin_signed_in?
      admin_dash
    elsif customer_signed_in?
      customer_dash
    elsif agent_signed_in?
      agent_dash
    else
      redirect_to root_path
    end
  end

  private

  def admin_dash
    @admin = current_admin
    render "admins/show.html.erb"
  end

  def customer_dash
    @customer = current_customer
    render "customers/show.html.erb"
  end

  def agent_dash
    @agent = current_agent
    render "agents/show.html.erb"
  end

end
