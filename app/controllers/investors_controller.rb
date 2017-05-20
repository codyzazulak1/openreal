class InvestorsController < ApplicationController

	def create
		@investor = Investor.new(investor_params)

		if @investor.save!
			redirect_to investors_path
		else
			redirect_to investors_path
			flash[:error] = "Something went wrong, please try again."
		end

	end

	private

	def investor_params
		params.require(:investor).permit(:first_name, :last_name, :email)
	end
end