class WishlistsController < ApplicationController

  def index
    @customer = Customer.find(params[:customer_id])
    @wishlists = @customer.wishlists
  end

  def show
    @wishlist = Wishlist.find(params[:id])
  end

  def new
    @customer = Customer.find(params[:customer_id])
    @wishlist = @customer.wishlists.new
  end

  def create
    @customer = Customer.find(params[:customer_id])
    @wishlist = @customer.wishlists.new(wishlist_params)
    if @wishlist.save
      redirect_to customer_wishlists_path(@customer)
    else
      redirect_to new_customer_wishlist_path
    end
  end

  private

  def wishlist_params
    params.require(:wishlist).permit(:title)
  end

end
