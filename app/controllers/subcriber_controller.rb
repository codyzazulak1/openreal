class SubscribersController < ApplicationController

def index
	@subcriber = Subcriber.all

end

def create
	@subcriber = Subscriber.new(subscriber_params)

	if @subcriber.save 
		respond_to do |format|
			format.js
		end
	end

end

def new
	@subcriber = Subscriber.new
end


private 

def subcriber_params
	params.require(:subcriber).permit(:full_name, :email, :id)
	
end

end
