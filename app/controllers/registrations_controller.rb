class RegistrationsController < Devise::RegistrationsController

  private

    def sign_up_params
      if resource_class == Admin
        params.require(:admin).permit(:first_name, :last_name, :email, :password, :password_confirmation)
      elsif resource_class == Agent
        params.require(:agent).permit(:first_name, :last_name, :email, :password, :password_confirmation)
      elsif resource_class == Customer
        params.require(:customer).permit(:first_name, :last_name, :email, :password, :password_confirmation)
      end
    end

    def account_update_params
      if resource_class == Admin
        params.require(:admin).permit(:first_name, :last_name, :email, :password, :password_confirmation)
      elsif resource_class == Agent
        params.require(:agent).permit(:first_name, :last_name, :email, :password, :password_confirmation)
      elsif resource_class == Customer
        params.require(:customer).permit(:first_name, :last_name, :email, :password, :password_confirmation)
      end
    end

end
