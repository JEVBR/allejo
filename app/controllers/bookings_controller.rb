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

  private

  def set_booking
    @booking = Booking.find(params[:id])
    authorize @booking
  end

  def booking_params
    params.require(:booking).permit(:start_time, :end_time, :pitch_id, :date, :player_name, :player_phone)
  end
end
