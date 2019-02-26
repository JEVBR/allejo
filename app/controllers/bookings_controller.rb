class BookingsController < ApplicationController

  def create
    @booking = Booking.new
    authorize @booking
    @booking.pitch_id = params[:pitch_id]
    @booking.user_id = current_user.id
  end

  private

  def booking_params
    params.require(:booking).permit(:start_time, :end_time)
  end
end
