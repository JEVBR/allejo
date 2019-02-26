class BookingsController < ApplicationController
  def create
    @booking = Booking.new
    authorize @booking

  end
end
