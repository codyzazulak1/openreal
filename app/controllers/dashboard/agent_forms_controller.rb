class Dashboard::AgentFormsController < ApplicationController

  before_action :authenticate_admin!

  def index
    @aforms = AgentForm.all
  end

end
