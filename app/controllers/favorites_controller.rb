class FavoritesController < ApplicationController

  def index
    @customer = Customer.find(params[:customer_id])
    @favorites = @customer.favorites
  end

  def create
    @customer = Customer.find(params[:customer_id])
    @property = Property.find(params[:pid])

    @favorite = Favorite.new(customer: @customer, property: @property)

    if @favorite.save

    end
  end

  private

end
