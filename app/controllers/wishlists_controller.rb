class WishlistsController < ApplicationController

  def index
    @customer = Customer.find(params[:customer_id])
    @wishlists = @customer.wishlists
    @favorites = @customer.favorites
    @list = Wishlist.new(customer: @customer)
  end

  def show
    @wishlist = Wishlist.find(params[:id])
    @favorites = @wishlist.favorites
    @customer = Customer.find(params[:customer_id])
  end

  def new

  end

  def create
    @list = Wishlist.new(customer_id: params[:customer_id], name: params[:wishlist][:name])
    @list.save
    @customer = Customer.find(params[:customer_id])
    @wishlists = @customer.wishlists
  end

  def destroy

  end

  private



end
