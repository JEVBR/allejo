# Preview all emails at http://localhost:3000/rails/mailers/booking_mailer
class BookingMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/booking_mailer/match_day_is_coming
  def match_day_is_coming
    BookingMailer.match_day_is_coming
  end

end
