class RegistrationsController < Devise::RegistrationsController
  private

  def sign_up_params
    params.require(:user).permit(:first_name,
                                 :last_name,
                                 :phone,
                                 :nickname,
                                 :cpf,
                                 :address,
                                 :email,
                                 :password,
                                 :password_confirmation,
                                 :position,
                                 :photo)
  end

  def account_update_params
    params.require(:user).permit(:first_name,
                                 :last_name,
                                 :phone,
                                 :nickname,
                                 :cpf,
                                 :address,
                                 :email,
                                 :position,
                                 :password,
                                 :password_confirmation,
                                 :current_password,
                                 :photo)
  end
end
