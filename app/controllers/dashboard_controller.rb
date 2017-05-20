class DashboardController < ApplicationController

  before_action :authenticate_admin!

  def index
    @properties = Property.all
    @contacts = ContactForm.all
    @aforms = AgentForm.all
    @investors = Investor.all
  end

end
