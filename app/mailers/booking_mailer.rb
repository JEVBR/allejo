class BookingMailer < ApplicationMailer
  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.booking_mailer.match_day_is_coming.subject
  #
  def match_day_is_coming(user_id)
    user = User.find(user_id)
    @first_name = user.first_name
    mail(to: user.email, subject: 'Não esqueça do jogo amanhã')
  end
end
