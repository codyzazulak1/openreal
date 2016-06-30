class AdminsController < ApplicationController

  def show
    @admin = current_admin
  end

end
