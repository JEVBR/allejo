class UsersController < ApplicationController
  def show
    @user = current_user
    authorize @user
    @pitches = @user.pitches.all

    bookings = Booking.joins(:participants).where(participants: { user: current_user }) # get all bookings where current_user is a participant
    @guest_bookings = bookings.where('start_time > ?', DateTime.now).where.not(user: current_user).order(start_time: :asc)
    @host_bookings = bookings.where('start_time > ?', DateTime.now).where(user: current_user).order(start_time: :asc)

    params[:pitch].present? ? @pitch = Pitch.find(params[:pitch]) : @pitch = @pitches.first

    params[:date] = Date.today.strftime('%F') unless params[:date].present?
    @date_select = params[:date].to_date
  end

  # Here from AJAX call:
  def owner_update
    @user = current_user
    authorize @user
    @test_data = "This is going to the users page"
  end

  private

  def user_params
    params.require(:user).permit(:photo, :pitch)
  end
end
