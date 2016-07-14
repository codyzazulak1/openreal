class FavoritesController < ApplicationController

  def index
    @customer = Customer.find(params[:customer_id])
    @favorites = @customer.favorites
  end

  private

end
