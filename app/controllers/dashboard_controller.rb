class DashboardController < ApplicationController

  def index
    @properties = Property.all
    @contacts = ContactForm.all
    @customers = Customer.all
  end

end
