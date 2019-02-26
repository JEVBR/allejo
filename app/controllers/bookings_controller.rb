class BookingsController < ApplicationController

  def start_time
    start_year = booking_params["start_time(1i)"].to_i
    start_month = booking_params["start_time(2i)"].to_i
    start_day = booking_params["start_time(3i)"].to_i
    start_hour = booking_params["start_time(4i)"].to_i
    start_minute = booking_params["start_time(5i)"].to_i
    DateTime.new(start_year, start_month, start_day, start_hour, start_minute)
  end

  def end_time
    end_year = booking_params["end_time(1i)"].to_i
    end_month = booking_params["end_time(2i)"].to_i
    end_day = booking_params["end_time(3i)"].to_i
    end_hour = booking_params["end_time(4i)"].to_i
    end_minute = booking_params["end_time(5i)"].to_i
    DateTime.new(end_year, end_month, end_day, end_hour, end_minute)
  end

  def create
    @booking = Booking.new
    authorize @booking
    @booking.pitch_id = params[:pitch_id]
    @booking.user_id = current_user.id

    @booking.start_time = start_time
    @booking.end_time = end_time
    if @booking.valid?
      @booking.save
      redirect_to pitch_path(@booking.pitch), notice: "Reserva efetuada com sucesso"
    else
      redirect_to pitch_path(@booking.pitch), alert: "Horário indisponível"
    end
  end

  private

  def booking_params
    params.require(:booking).permit(:start_time, :end_time)
  end
end
