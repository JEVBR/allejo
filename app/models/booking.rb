class Booking < ApplicationRecord
  belongs_to :pitch
  belongs_to :user

  has_many :participants, dependent: :destroy
  has_many :users, through: :participants

  validates :pitch, presence: true
  validates :user, presence: true

  validates :start_time, presence: true
  validates :end_time, presence: true

  validate :check_end_time_greater_start_time
  validate :check_availability
  validate :check_start_time_equal_end_time
  validate :check_start_time_in_the_past
  validate :check_business_hours

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

  def check_start_time_in_the_past
    if start_time < DateTime.now
      errors.add(:start_time, "start_time can't be in the past")
    end
  end

  def check_business_hours
    opening_time = start_time.to_date.beginning_of_day + pitch.opening_time.hours
    closing_time = start_time.to_date.beginning_of_day + pitch.closing_time.hours

    if start_time < opening_time || start_time >= closing_time
      errors.add(:start_time, "start_time should be included in business_hours")
    end

    if end_time < opening_time || end_time > closing_time
      errors.add(:end_time, "end_time should be included in business_hours")
    end
  end

  def self.pitch_daily_schedule(day, pitch, slot_duration)
    day = day.to_date.beginning_of_day

    booking = Booking.new
    booking.pitch = pitch
    booking.user = User.first # random user, just to booking be valid

    daily_schedule = []

    (pitch.opening_time..(pitch.closing_time - 1)).to_a.each do |slot| # minutes between 00h and (24h - last slot)
      duration = slot_duration

      init_time = day + (duration.minutes * slot)
      end_time = day + (duration.minutes * (slot + 1))

      booking.start_time = init_time
      booking.end_time = end_time

      if booking.valid?
        available = true
      else
        available = false
        booked = pitch.bookings.find_by("(? < start_time AND ? > end_time) OR (? > start_time AND ? < end_time)", init_time, end_time, end_time, init_time)
      end

      daily_schedule << { start_time: init_time, end_time: end_time, available: available, booking: booked }
    end
    daily_schedule
  end
end
