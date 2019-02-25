class UsersController < ApplicationController
  def show
    @user = current_user
    authorize @user
  end

  private

  def user_params
    params.require(:user).permit(:photo, :description)
  end
end
