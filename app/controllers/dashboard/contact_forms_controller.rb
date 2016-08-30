class Dashboard::ContactFormsController < ApplicationController

  def index
    @forms = ContactForm.all
  end

end
