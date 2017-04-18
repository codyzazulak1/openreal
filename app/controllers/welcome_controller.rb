class WelcomeController < ApplicationController

  def index
    @properties_p = Property.all
    @property = Property.first
    @user = current_user
    @just_listed = Property.where('created_at >= ?', 2.days.ago)
    @featured = Property.all.sample(3)
    @new_properties = Property.just_listed(3)
    # @properties_sold = @properties_p.where('id NOT IN (SELECT DISTINCT(property_id) FROM contact_forms)').where('list_price_cents = ?', 0).count
    @properties_active = @properties_p.where('list_price_cents > ?', 0).count
    

    # Properties to be featured on front page
    feature_prop = Property.where("list_price_cents > ?", 0).order("created_at DESC").to_a
    feature_prop.each_with_index do |p, i|
      if i == 0
        @feature1_property = p
      elsif i == 1
        @feature2_property = p
      end
    end

    #meta tags
    set_meta_tags title: "Openreal – Online Platform for Selling Properties by Home Owners", description: "Canada’s first online platform for home owners to sell their property fast, worry free, with or without real estate agent. Sell your home for cash quickly"
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
    #meta tags
    set_meta_tags title: "Online Platform for Selling Properties by Home Owners | How",
      description: "Canada’s 1st online platform for home owners to sell their property fast, worry free, with or without real estate agent. Sell your home for cash quickly. How"
  end

  def faq 
    #meta tags
    set_meta_tags title: "Online Platform for Selling Properties by Home Owners | FAQ",
      description: "Canada’s 1st online platform for home owners to sell their property fast, worry free, with or without real estate agent. Sell your home for cash quickly. FAQ"

    flash[:notice] = "FAQ temporarily unavailable. Will be back soon!"
    redirect_to action: "contact"
  end

  def pricing
     #meta tags
    set_meta_tags title: "Online Platform for Selling Properties by Home Owners | Pricing",
      description: "Canada’s 1st online platform for home owners to sell their property fast, worry free, with / without real estate agent. Sell your home for cash quick. Pricing"
  end

  def terms
    #meta tags
    set_meta_tags title: "Online Platform for Selling Properties by Home Owners | Terms",
      description: "Canada’s 1st online platform for home owners to sell their property fast, worry free, with / without real estate agent. Sell your home for cash quick. Terms"
  end

  def contact
    @subscriber = Subscriber.new

    #meta tags
    set_meta_tags title: "Online Platform for Selling Properties by Home Owners | Contact",
      description: "Canada’s 1st online platform for home owners to sell their property fast, worry free, with / without real estate agent. Sell your home for cash quick. Contact"
  end

  def mortcalc
  end

  def agents
    @aform = AgentForm.new

    #meta tags
    set_meta_tags title: "Online Platform for Selling Properties by Home Owners | Agents",
      description: "Canada’s 1st online platform for home owners to sell their property fast, worry free, with / without real estate agent. Sell your home for cash quick. Agents"
  end

  def listings
    @properties_p = Property.all
  end


end
