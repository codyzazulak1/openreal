class RegistrationsController < Devise::RegistrationsController

  private

    def current_user
      current_admin || current_customer
    end

    def sign_up_params
      params.require(:admin).permit(:first_name, :last_name, :email, :password)
    end

    def account_update_params
      params.require(:admin).permit(:first_name, :last_name, :email, :password)
    end

end
