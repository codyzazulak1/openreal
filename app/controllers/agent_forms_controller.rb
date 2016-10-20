class AgentFormsController < ApplicationController

  def new
    @aform = AgentForm.new
  end

  def create
    @aform = AgentForm.new(agent_form_params)

    if @aform.save
      redirect_to agents_path
    end
  end

  private

  def agent_form_params
    params.require(:agent_form).permit(:full_name, :email, :company_name)
  end

end
