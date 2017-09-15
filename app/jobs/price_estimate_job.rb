class PriceEstimateJob < ActiveJob::Base
  queue_as :offers
	
	require_relative '../../lib/autoprop.rb'
	include Autoprop

  def perform(address, login, p)
   res = Autoprop.finden(address,login, p)
	 return res
  end
end
