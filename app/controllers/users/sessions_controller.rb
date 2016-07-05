class Users::SessionsController < Devise::SessionsController
# before_action :configure_sign_in_params, only: [:create]

  # GET /resource/sign_in
  def new
   if admin_signed_in?
     redirect_to dashboard_path
     flash[:notice] = "You are already signed in as an admin."
   elsif customer_signed_in?
     redirect_to dashboard_path
     flash[:notice] = "You are already signed in as a customer."
   else
     super
   end
  end

  # POST /resource/sign_in
  # def create
  #   super
  # end

  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end
end
