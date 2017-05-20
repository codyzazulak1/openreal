class Dashboard::InvestorsController < ApplicationController
	def index
		@investors = Investor.all
	end

	def destroy
		@investor = Investor.find(params[:id])

		if @investor.destroy
			redirect_to dashboard_investors_path
			flash[:notice] = "Subscriber #{@investor.first_name} #{@investor.last_name} Deleted"
		end
	end
end