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

      send_email_time = @booking.start_time.to_datetime - 1.days
      # job_id = MatchDayMailerJob.set(wait_until: send_email_time).perform_later(@booking.id).job_id
      # @booking.update_column(:match_day_mailer_job_id, job_id)

      participant = Participant.new(booking: @booking, user: current_user, confirmed: true)
      participant.save

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
    job_id = @booking.match_day_mailer_job_id
    find_jid = Sidekiq::ScheduledSet.new.find { |a| job_id }

    if find_jid.to_s.present?
      jid = find_jid.item["jid"]
      Sidekiq::ScheduledSet.new.find_job(jid).delete
    end

    BookingCanceledMailerJob.perform_now(@booking.id)

    @booking.destroy
    if current_user.owner?
      redirect_to request.env["HTTP_REFERER"]
    else
      redirect_to users_show_path
    end
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
