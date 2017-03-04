class Dashboard::SubscribersController < ApplicationController

	def index
		@subscribers = Subscriber.all
	end

	def destroy
		@subscriber = Subscriber.find(params[:id])

		if @subscriber.delete
			redirect_to dashboard_subscribers_path
			flash[:notice] = "Subscriber #{@subscriber.full_name} Deleted"
		end
	end
end
