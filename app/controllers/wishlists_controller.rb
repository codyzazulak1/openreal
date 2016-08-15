class WishlistsController < ApplicationController

  def index
    @customer = Customer.find(params[:customer_id])
    @wishlists = @customer.wishlists
    @favorites = @customer.favorites
    @list = Wishlist.new(customer: @customer)
  end

  def show
    @wishlist = Wishlist.find(params[:wishlist])
  end

  def new

  end

  def create
    @list = Wishlist.new(name: params[:name])

    if @list.save

    end

  end

  def destroy

  end

end
