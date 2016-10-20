class AgentFormsController < ApplicationController

  def new
    @aform = AgentForm.new
  end

  def create
    @aform = AgentForm.find(params[:id])

    if @aform.save
    end
  end

end
