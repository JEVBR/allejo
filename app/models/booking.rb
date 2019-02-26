class Booking < ApplicationRecord
  belongs_to :pitch
  belongs_to :user

  validates :pitch, presence: true
  validates :user, presence: true

  validates :start_time, presence: true
  validates :end_time, presence: true

  validate :check_end_time_greater_start_time
  validate :check_availability
  validate :check_start_time_equal_end_time

  def check_end_time_greater_start_time
    if start_time > end_time
      errors.add(:start_time, "start_time can't be greater than end_time")
    end
  end

  def check_availability
    new_booking_start_time = start_time
    new_booking_end_time = end_time

    if pitch.bookings.where(
      "? < start_time AND ? > end_time", new_booking_start_time, new_booking_end_time).size.positive?
      errors.add(:start_time, "there is a game in this time")

    elsif pitch.bookings.where(
      "? > start_time AND ? < end_time", new_booking_end_time, new_booking_start_time).size.positive?
      errors.add(:end_time, "there is a game in this time")
    end
  end

  def check_start_time_equal_end_time
    if start_time == end_time
      errors.add(:start_time, "start_time can't be equal end_time")
    end
  end
end
