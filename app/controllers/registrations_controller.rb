class RegistrationsController < Devise::RegistrationsController
  private

  def sign_up_params
    params.require(:user).permit(:first_name,
                                 :last_name,
                                 :phone,
                                 :nickname,
                                 :CPF,
                                 :address,
                                 :email,
                                 :password,
                                 :password_confirmation,
                                 :photo,
                                 :description)
  end

  def account_update_params
    params.require(:user).permit(:first_name,
                                 :last_name,
                                 :phone,
                                 :nickname,
                                 :CPF,
                                 :email,
                                 :password,
                                 :password_confirmation,
                                 :current_password,
                                 :photo,
                                 :description)
  end
end
