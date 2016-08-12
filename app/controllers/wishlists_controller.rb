class WishlistsController < ApplicationController

  def index
    @wishlists = Customer.find(params[:customer_id]).wishlists
    @favorites = Customer.find(params[:customer_id]).favorites
  end

  def show
    @wishlist = Wishlist.find(params[:wishlist])
  end

  def new

  end

  def create

  end

  def destroy

  end

end
