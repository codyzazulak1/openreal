class WelcomeController < ApplicationController

  def index
    @properties_p = Property.all
    @property = Property.first
    @user = current_user
    @just_listed = Property.where('created_at >= ?', 2.days.ago)
    @featured = Property.all.sample(3)
    @new_properties = Property.just_listed(3)
    @properties_sold = @properties_p.where('list_price_cents = ?', 0).count
    

    # Properties to be featured on front page
    feature_prop = Property.where("list_price_cents > ?", 0).order("created_at DESC").to_a
    feature_prop.each_with_index do |p, i|
      if i == 0
        @feature1_property = p
      elsif i == 1
        @feature2_property = p
      end
    end
          

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
    flash[:notice] = "FAQ temporarily unavailable. Will be back soon!"
    redirect_to action: "contact"
  end

  def pricing
  end

  def terms
  end

  def contact
    @subscriber = Subscriber.new
  end

  def mortcalc
  end

  def agents
    @aform = AgentForm.new
  end

  def listings
    @properties_p = Property.all
  end


end
