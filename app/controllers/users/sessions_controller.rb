class Users::SessionsController < Devise::SessionsController
# before_action :configure_sign_in_params, only: [:create]
  respond_to :json

  # GET /resource/sign_in

  # def new
  #  if logged_in? === current_agent
  #    redirect_to agents_dashboard_path
  #    flash[:notice] = "You are already signed in as #{who_logged_in}."
  #   elsif logged_in === current_admin
  #     redirect_to dashboard_path
  #     flash[:notice] = "You are already signed in as #{who_logged_in}"
  #  end
  # end

  # POST /resource/sign_in
  # def create
  #   super
  # end

  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end

  protected
  def after_sign_in_path_for(resource)
    if current_agent === resource
      agents_dashboard_path
    elsif current_admin === resource
      dashboard_path
    end
  end
  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end
end
