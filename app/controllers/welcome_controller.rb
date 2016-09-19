class WelcomeController < ApplicationController

  def index
    @user = current_user
    @just_listed = Property.where('created_at >= ?', 2.days.ago)
    @featured = Property.all.sample(3)
    @new_properties = Property.just_listed(3)
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

  def faq
  end

  def terms
  end

  def contact 
  end

end
