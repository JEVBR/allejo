class BookingsController < ApplicationController
  before_action :set_booking, only: [:show, :destroy]

  def create
    @booking = Booking.new(booking_params)
    @booking.pitch_id = params[:pitch_id]
    authorize @booking
    @booking.user = current_user

    date = params[:booking][:start_time].to_datetime.strftime("%F")

    if @booking.valid?
      @booking.save

      participant = Participant.new(booking: @booking, user: current_user, confirmed: true)
      participant.save

      BookingMailer.match_day_is_coming(@booking).deliver_now
      # redirect_to pitch_path(@booking.pitch, date: date), notice: "Reserva efetuada com sucesso"
      redirect_to request.env["HTTP_REFERER"], notice: "Reserva efetuada com sucesso"
    else
      # redirect_to pitch_path(@booking.pitch), alert: "Horário indisponível"
      redirect_to request.env["HTTP_REFERER"], alert: "Horário indisponível"
    end
  end

  def show
    @confirmed_list = @booking.participants.where(confirmed: true)
    @not_confirmed_list = @booking.participants.where(confirmed: false)
  end

  def destroy
    @booking.destroy
    redirect_to users_show_path
  end

  def unblock_day
    start_time = params[:booking][:start_time]
    end_time = params[:booking][:end_time]
    pitch = Pitch.find(params[:pitch_id])
    booking = pitch.bookings.find_by(start_time: start_time, end_time: end_time)
    authorize booking
    booking.destroy
    redirect_to request.env["HTTP_REFERER"], notice: "Dia desbloqueado"
  end

  private

  def set_booking
    @booking = Booking.find(params[:id])
    authorize @booking
  end

  def booking_params
    params.require(:booking).permit(:start_time, :end_time, :pitch_id, :date, :player_name, :player_phone, :blocked)
  end
end
