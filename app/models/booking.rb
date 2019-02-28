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

  def self.pitch_daily_schedule(day, pitch, slot_duration)
    day = day.in_time_zone(-3) + 3.hours
    booking = Booking.new
    booking.pitch = pitch
    booking.user = User.first # random user, just to booking be valid
    daily_schedule = []
    (0..((1440 - slot_duration) / slot_duration)).to_a.each do |slot| # minutes between 00h and (24h - last slot)
      duration = slot_duration
      booking.start_time = day + (duration.minutes * slot)
      booking.end_time = day + (duration.minutes * (slot + 1))

      init_time = day + (duration.minutes * slot)
      end_time = day + (duration.minutes * (slot + 1))

      booking.valid? ? available = true : available = false

      daily_schedule << { start_time: init_time, end_time: end_time, available: available }
    end
    daily_schedule
  end
end
