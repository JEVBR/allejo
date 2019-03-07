class MatchDayMailerJob < ApplicationJob
  queue_as :default

  def perform(booking_id)
    # Do something later
    booking = Booking.find(booking_id)
    booking.participants.each do |participant|
      BookingMailer.match_day_is_coming(participant.user.id, booking.id).deliver_now
    end
  end
end
