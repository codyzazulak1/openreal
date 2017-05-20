class InvestorsController < ApplicationController

	def create
		@investor = Investor.new(investor_params)
		@investor.save!

	end

	private

	def investor_params
		params.require(:investor).permit(:first_name, :last_name, :email)
	end
end