class Dashboard::ContactFormsController < ApplicationController

  before_action :authenticate_admin!

  def index
    @forms = ContactForm.all

    @forms_pagination = @forms.paginate(:page => params[:page], :per_page => 5)

  end

  def show
    @form = ContactForm.find(params[:id])
  end

  def new
    @form = ContactForm.new
  end

  def create
  end

  def update
    @form = ContactForm.find(params[:id])

    if @form.update_attributes({status: params[:status]})
      redirect_to dashboard_contact_forms_path
    end
  end

  def destroy
    @form = ContactForm.find(params[:id])
    @form.destroy
    redirect_to dashboard_contact_forms_path, notice: "Deleted #{@form.name}"
  end

  private

end
