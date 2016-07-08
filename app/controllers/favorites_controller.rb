class FavoritesController < ApplicationController

  before_action :find_property

  def create
    if Favorite.create(property: @property, customer: current_customer)
      redirect_to @property, notice: "Favorited successfully"
    else
      redirect_to @property, alert: "Something went wrong."
    end
  end

  def destroy
    Favorite.find_by(property: @property, customer: current_customer).destroy
    redirect_to @property, notice: "Unfavorited successfully"
  end

  private

  def find_property
    @property = Property.find(params[:property_id] || params[:id])
  end

end
