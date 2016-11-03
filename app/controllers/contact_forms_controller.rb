class ContactFormsController < ApplicationController

  def index
    @cforms = ContactForm.all
  end

  def new
    @cform = ContactForm.new
  end

  def create
    @cform = ContactForm.new(contact_form_params)
    @cform[:status] = 'unanswered'
    @cform[:sub_type] = 'Inquiry'

    if @cform.save

      respond_to do |format|
        format.js
      end

    end
  end

  private

  def contact_form_params
    params.require(:contact_form).permit(:name, :email, :phone, :notes, :property_id, :status, :sub_type)
  end

end
