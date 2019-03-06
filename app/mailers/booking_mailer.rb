class BookingMailer < ApplicationMailer
  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.booking_mailer.match_day_is_coming.subject
  #
  def match_day_is_coming(booking)
    booking.participants.each do |participant|
      @first_name = participant.user.first_name
      mail(to: participant.user.email, subject: 'Não esqueça do jogo amanhã')
    end
  end
end
