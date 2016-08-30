class Dashboard::ContactFormsController < ApplicationController

  def index
    @forms = ContactForm.all
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
      redirect_to dashboard_contact_form_path(@form)
    end
  end

  def destroy
    @form = Contactform.find(params[:id])
  end

  private

end
