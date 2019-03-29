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
    daily_checksum
  end

  # Here from AJAX call:
  def owner_update
    @user = current_user
    authorize @user

    @date_select = params[:date].to_date
    @pitch = Pitch.find(params[:pitch_id])
    daily_checksum
  end

  def daily_checksum
    return unless current_user.owner?

    @checksum = ""
    (0..3).to_a.each do |c|
      @day_schedule = Booking.pitch_daily_schedule(@date_select + c, @pitch, 60)

      @day_schedule.each do |b|
        @checksum += b[:available] ? "Y" : "N"
      end
    end
  end

  private

  def user_params
    params.require(:user).permit(:photo, :pitch)
  end
end
