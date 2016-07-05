class WelcomeController < ApplicationController

  def index
    if admin_signed_in?
      @user = current_admin
    elsif customer_signed_in?
      @user = current_customer
    elsif agent_signed_in?
      @user = current_agent
    end
  end

  def login
    if logged_in?
      flash[:notice] = "You're already logged in"
      redirect_to dashboard_path
    end
  end

end
