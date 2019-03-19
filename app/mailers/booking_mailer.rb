class BookingMailer < ApplicationMailer
  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.booking_mailer.match_day_is_coming.subject
  #
  def match_day_is_coming(user_id, booking_id)
    user = User.find(user_id)
    booking = Booking.find(booking_id)
    pitch = Pitch.find(booking.pitch.id)

    @first_name = user.first_name
    @date = booking.start_time.strftime("%d/%m")
    @pitch_company = pitch.company
    @address = pitch.address

    mail(to: user.email, subject: 'Não esqueça do jogo amanhã')
  end

  def booking_canceled(user_id, booking_id)
    user = User.find(user_id)
    booking = Booking.find(booking_id)
    pitch = Pitch.find(booking.pitch.id)

    @first_name = user.first_name
    @date = booking.start_time.strftime("%d/%m")
    @pitch_company = pitch.company
    @address = pitch.address

    mail(to: user.email, subject: 'Seu jogo foi cancelado')
  end
end
