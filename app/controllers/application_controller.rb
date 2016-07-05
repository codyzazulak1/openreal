class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def logged_in?
    admin_signed_in? || customer_signed_in? || agent_signed_in?
  end

  def who_logged_in
    if admin_signed_in?
      return Admin
    elsif customer_signed_in?
      return Customer
    elsif agent_signed_in?
      return Agent
    end
    return nil
  end

end
