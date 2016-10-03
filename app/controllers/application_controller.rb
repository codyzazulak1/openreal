class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :configure_permitted_params, if: :devise_controller?

  protected

  def logged_in?
    admin_signed_in? || customer_signed_in? || agent_signed_in?
  end

  def current_user
    if admin_signed_in?
      return current_admin
    elsif customer_signed_in?
      return current_customer
    elsif agent_signed_in?
      return current_agent
    end
    return nil
  end
# .for deprecated  
  def configure_permitted_params
    devise_parameter_sanitizer.permit(:sign_up){ |u|
      u.permit(:email, :password, :password_confirmation)
    }
  end

end
