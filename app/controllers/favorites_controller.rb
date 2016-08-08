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
      respond_to do |format|
        format.json {render json: {fid: @favorite.id}}
      end
    end
  end

  def destroy
    @customer = Customer.find(params[:customer_id])
    @favorite = Favorite.find(params[:fid])

    # if @favorite.destroy
    #   result = {message: "success"}
    # else
    #   result = {message: "failed"}
    # end

    if @favorite.destroy
      respond_to do |format|
        format.json {render json: {message: "success"}}
      end
    end
  end

  private
end
