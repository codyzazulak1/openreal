class SubscribersController < ApplicationController

def index

end

def create
	@subscriber = Subscriber.new(subscriber_params)

	if @subscriber.save 
		flash[:notice] = "Thank you!"
		redirect_to contact_path
	end

end

def new
	@subscriber = Subscriber.new
end


private 

def subscriber_params
	params.require(:subscriber).permit(:full_name, :email, :id)
	
end

end
