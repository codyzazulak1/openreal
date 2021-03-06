class Dashboard::ContactFormsController < ApplicationController

  before_action :authenticate_admin!
	
	require_relative '../../../lib/autoprop.rb'
	require_relative '../../../lib/eval.rb'
	
	include Autoprop
	include Evalbc

  def index
    @forms = ContactForm.all.order('created_at DESC')

    @forms_pagination = @forms.paginate(:page => params[:page], :per_page => 5)

  end

  def show
    @form = ContactForm.find(params[:id])
  	@pr_upgrades = PropertyUpgrade.where(property_id: @form.property_id)
		ary = []

		@pr_upgrades.each {|pu|
			ary << pu.upgrade_id unless pu.upgrade_id.nil?
		}
		
		@upgrades = []

		ary.each {|i|
			@upgrades << Upgrade.find(i)
		}

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

	def	price_estimate
		@contact_property = Property.find(params[:contact_form_id])
	
		address = @contact_property.address_name
		rg = ['unit', 'apartment', 'apt.', 'apt', 'suite']

		rg.each {|r|
			if address.downcase.include? r
				address = address.downcase.split(r)[1]
			else
				address
			end
		}
		puts address


		#@offer_info = Autoprop.finden(address, autoprop_login, autoprop_pw)
		@offer_info = Evalbc.finden(address)

		respond_to do |format|
			format.js
		end
	end
  private
	
	def	autoprop_login
		return ENV['aprop_login']
	end

	def autoprop_pw
		return ENV['aprop_pw']
	end
end
