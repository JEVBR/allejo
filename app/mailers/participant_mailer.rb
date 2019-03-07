class ParticipantMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.participant_mailer.new_invitation.subject
  #
  def new_invitation(participant_id, host_id)
    participant = Participant.find(participant_id)
    user = User.find(participant.user_id)
    booking = Booking.find(participant.booking_id)
    pitch = Pitch.find(booking.pitch_id)
    host = User.find(host_id)

    @greeting = "Hi"

    mail(to: user.email, subject: "#{host.full_name} te convidou para uma partida de #{pitch.category.name}")
  end
end
