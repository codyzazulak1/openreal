class DashboardController < ApplicationController

  before_action :authenticate_admin!

  def index
    @properties = Property.all
    @contacts = ContactForm.all
    @customers = Customer.all

  end

end
