class UsersController < ApplicationController
  def show
    @user = current_user
    authorize @user
    @pitches = @user.pitches.all

    bookings = Booking.joins(:participants).where(participants: { user: current_user }) # get all bookings where current_user is a participant
    @upcoming_bookings = bookings.where('start_time > ?', DateTime.now).order(start_time: :asc)
    @past_bookings = bookings.where('start_time < ?', DateTime.now).order(start_time: :asc)

    params[:pitch].present? ? @pitch = Pitch.find(params[:pitch]) : @pitch = @pitches.first
    params[:date].present? ? @date_select = params[:date].to_date : @date_select = Date.today
  end

  private

  def user_params
    params.require(:user).permit(:photo, :pitch)
  end
end
