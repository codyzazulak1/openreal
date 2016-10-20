class Dashboard::AgentFormsController < ApplicationController

  before_action :authentice_admin!

  def index
    @aforms = AgentForm.all
  end

end
