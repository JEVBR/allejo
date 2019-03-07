class ParticipantsController < ApplicationController
  before_action :set_participant, only: [:destroy]

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

      unless user == current_user
        ParticipantMailer.new_invitation(participant.id, current_user.id).deliver_now
      end

      redirect_to request.env["HTTP_REFERER"], notice: "#{user.full_name} foi adicionado a sua partida"
    else
      redirect_to request.env["HTTP_REFERER"], alert: "#{user.full_name} já foi adicionado a sua partida"
    end
  end

  def destroy
    @participant.destroy
    redirect_to request.env["HTTP_REFERER"], alert: "#{@participant.user.full_name} foi removido da partida"
  end

  def change_confirm
    @participant = Participant.find(params[:format])
    authorize @participant
    @participant.confirmed = !@participant.confirmed
    @participant.save
    if @participant.confirmed == true
      redirect_to request.env["HTTP_REFERER"], notice: "Presença confirmada"
    else
      redirect_to request.env["HTTP_REFERER"], alert: "Presença cancelada"
    end
  end

  private

  def set_participant
    @participant = Participant.find(params[:id])
    authorize @participant
  end
end
