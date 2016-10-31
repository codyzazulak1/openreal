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
      redirect_to :root
    end
  end

  def register
    if logged_in?
      flash[:notice] = "You're already logged in"
      redirect_to dashboard_path
    end
  end

  def logout
    if logged_in?
      current_admin.destroy
    end
    redirect_to dashboard_path
  end

  def howitworks
  end

  def faq
  end

  def pricing
  end

  def terms
  end

  def contact
  end

  def mortcalc
  end

  def agents
    @aform = AgentForm.new
  end

  def listings
    @properties_p = Property.all
  end

  def view_listing
    @properties = Property.all
    @prop = Property.find(params[:id])
  end

end
