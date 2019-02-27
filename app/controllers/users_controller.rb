class UsersController < ApplicationController
  def show
    @user = current_user
    authorize @user
    @pitches = @user.pitches.all
    # raise
    params[:pitch].present? ? @pitch = Pitch.find(params[:pitch]) : @pitch = @pitches.first
    params[:date].present? ? @date_select = params[:date].to_date : @date_select = Date.today
  end

  private

  def user_params
    params.require(:user).permit(:photo, :pitch)
  end
end
