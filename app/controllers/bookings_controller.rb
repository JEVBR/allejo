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
    @booking = Booking.new(booking_params)
    authorize @booking
    @booking.user = current_user

    params[:date].present? ? date = params[:date].to_datetime : date = Date.today
    # pitch_id = params[:pitch_id]
    # @pitch = Pitch.find(pitch_id)
    # @daily_schedule = Booking.pitch_daily_schedule(date, @pitch, 120)
    # @booking.start_time = start_time
    # @booking.end_time = end_time
    if @booking.valid?
      @booking.save
      # render "pitches/show", :daily_schedule => @daily_schedule, :pitch => @pitch, :date => params[:date]
      redirect_to pitch_path(@booking.pitch, date: params[:date]), notice: "Reserva efetuada com sucesso"
    else
      redirect_to pitch_path(@booking.pitch), alert: "Horário indisponível"
    end
  end

  private

  def booking_params
    params.require(:booking).permit(:start_time, :end_time, :pitch_id, :date)
  end
end
