class Dashboard::AgentFormsController < ApplicationController

  before_action :authenticate_admin!

  def index
    @aforms = AgentForm.all
  end

  def edit
    @aform = AgentForm.find(params[:id])
  end

  def update
    @aform = AgentForm.find(params[:id])

    if @aform.update_attributes(aform_params)
      redirect_to dashboard_agent_forms_path
      flash[:notice] = "Updated #{@aform.full_name}'s form"
    end
  end

  def destroy
    @aform = AgentForm.find(params[:id])

    if @aform.destroy
      redirect_to dashboard_agent_forms_path
      flash[:notice] = "Agent Form for #{@aform.full_name} Deleted!"
    end

  end

  private

  def aform_params
    params.require(:agent_form).permit(:full_name, :email, :company_name)
  end

end
