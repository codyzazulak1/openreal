class WelcomeController < ApplicationController

  def index
    @user = current_user
  end

  def login
    if logged_in?
      flash[:notice] = "You're already logged in"
      redirect_to dashboard_path
    end
  end

  def register
    if logged_in?
      flash[:notice] = "You're already logged in"
      redirect_to dashboard_path
    end
  end

  def howitworks

  end

end
