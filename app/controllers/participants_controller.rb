class ParticipantsController < ApplicationController
  def create
    user = User.find(params[:participant_id])
    booking = Booking.find(params[:booking_id])

    participant = Participant.new
    authorize participant

    if user.present? && booking.present?
      participant = Participant.new(booking: booking, user: user)
    end

    if participant.valid?
      participant.save
      redirect_to request.env["HTTP_REFERER"], notice: "#{user.first_name} #{user.last_name} foi adicionado a sua partida"
    else
      redirect_to request.env["HTTP_REFERER"], alert: "#{user.first_name} #{user.last_name} já foi adicionado a sua partida"
    end
  end

  def change_confirm
    @participant = Participant.find(params[:format])
    authorize @participant
    @participant.confirmed = !@participant.confirmed
    @participant.save
  end
end
