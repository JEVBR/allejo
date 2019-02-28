class BookingsController < ApplicationController
  def create
    @booking = Booking.new(booking_params)
    authorize @booking
    @booking.user = current_user

    date = params[:booking][:start_time].to_datetime.strftime("%F")

    if @booking.valid?
      @booking.save

      unless current_user.owner?
        participant = Participant.new(booking: @booking, user: current_user)
        participant.save
      end
      # redirect_to pitch_path(@booking.pitch, date: date), notice: "Reserva efetuada com sucesso"
      redirect_to request.env["HTTP_REFERER"], notice: "Reserva efetuada com sucesso"
    else
      # redirect_to pitch_path(@booking.pitch), alert: "Horário indisponível"
      redirect_to request.env["HTTP_REFERER"], alert: "Horário indisponível"
    end
  end

  private

  def booking_params
    params.require(:booking).permit(:start_time, :end_time, :pitch_id, :date)
  end
end
