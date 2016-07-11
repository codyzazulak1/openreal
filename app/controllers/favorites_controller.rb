class FavoritesController < ApplicationController

  def index
    @customer = Customer.find(params[:customer_id])
    @favorites = @customer.favorites
  end

  def create
    @customer = current_customer
    @property = Property.find(params[:id])
    @favorite = @customer.favorites.create(property: @property)

    if @favorite.save
      redirect_to @property
    end

  end

  def destroy
  end

  private

end
