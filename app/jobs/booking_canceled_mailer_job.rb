class BookingCanceledMailerJob < ApplicationJob
  queue_as :default

  def perform(booking_id)
    booking = Booking.find(booking_id)
    booking.participants.each do |participant|
      BookingMailer.booking_canceled(participant.user.id, booking.id).deliver_now
    end
  end
end
