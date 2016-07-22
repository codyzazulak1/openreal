class ContactFormsController < ApplicationController

  def index
    @cforms = ContactForm.all
  end

  def new
    @cform = ContactForm.new
  end

  def create
    @cform = ContactForm.new(contact_form_params)
    if @cform.save
      redirect_to contact_forms_path
    else
      redirect_to new_contact_form_path
    end
  end

  private

  def contact_form_params
    params.require(:contact_form).permit(:name, :email, :phone, :notes)
  end

end
