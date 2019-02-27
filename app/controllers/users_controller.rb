class UsersController < ApplicationController
  def show
    @user = current_user
    authorize @user
    @pitches = @user.pitches.all
  end

  private

  def user_params
    params.require(:user).permit(:photo)
  end
end
