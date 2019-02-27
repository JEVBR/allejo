class BookingsController < ApplicationController
  def create
    @booking = Booking.new(booking_params)
    authorize @booking
    @booking.user = current_user

    date = params[:booking][:start_time].to_datetime.strftime("%F")

    if @booking.valid?
      @booking.save
      redirect_to pitch_path(@booking.pitch, date: date), notice: "Reserva efetuada com sucesso"
    else
      redirect_to pitch_path(@booking.pitch), alert: "Horário indisponível"
    end
  end

  private

  def booking_params
    params.require(:booking).permit(:start_time, :end_time, :pitch_id, :date)
  end
end
