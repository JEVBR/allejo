class MonthlyPlayer < ApplicationRecord
  belongs_to :pitch

  has_many :bookings

  validates :start_time, presence: true
  validates :end_time, presence: true
  validates :player_name, presence: true
  validates :player_phone, presence: true
  # validates :player_email, presence: true
  validates :day_of_the_week, presence: true

  validate :check_end_time_greater_start_time
  validate :check_bookings

  after_create do
    start_day = Date.today + 1.days
    end_day = Date.today.month <= 6 ? Date.new(Date.today.year, 6, 30) : Date.new(Date.today.year, 12, 31)

    (start_day..end_day).to_a.each do |day|
      if day.wday == day_of_the_week.to_i
          booking = Booking.new(
          pitch_id: pitch.id,
          start_time: day + start_time.minutes,
          end_time: day + end_time.minutes,
          user_id: pitch.user.id,
          date: day,
          player_name: player_name,
          player_phone: player_phone,
          monthly_player_id: self.id
        )
          booking.save
      end
    end
  end

  before_destroy do
    self.bookings.where('start_time > ?', Date.today).destroy_all
    self.bookings.where('start_time < ?', Date.today).update_all("monthly_player_id = null")
  end

  after_update do
    self.bookings.where('start_time > ?', Date.today).destroy_all

    start_day = Date.today + 1.days
    end_day = Date.today.month <= 6 ? Date.new(Date.today.year, 6, 30) : Date.new(Date.today.year, 12, 31)

    (start_day..end_day).to_a.each do |day|
      if day.wday == day_of_the_week.to_i
          booking = Booking.new(
          pitch_id: pitch.id,
          start_time: day + start_time.minutes,
          end_time: day + end_time.minutes,
          user_id: pitch.user.id,
          date: day,
          player_name: player_name,
          player_phone: player_phone,
          monthly_player_id: self.id
        )
          booking.save
      end
    end
  end

  # after_destroy do
    # start_day = Date.today + 1.days
    # end_day = Date.today.month <= 6 ? Date.new(Date.today.year, 6, 30) : Date.new(Date.today.year, 12, 31)

    # (start_day..end_day).to_a.each do |day|
    #   if day.wday == day_of_the_week.to_i
    #     booking = Booking.find_by(
    #       pitch_id: pitch.id,
    #       start_time: day + start_time.minutes,
    #       end_time: day + end_time.minutes,
    #       user_id: pitch.user.id,
    #       player_name: player_name,
    #       player_phone: player_phone
    #     )
    #     booking.destroy
    #   end
    # end
  #   raise
  #   self.bookings.destroy_all.where()
  # end

  def check_end_time_greater_start_time
    if start_time >= end_time
      errors.add(:start_time, "start_time can't be greater than end_time")
    end
  end

  def check_bookings
    start_day = Date.today + 1.days
    end_day = Date.today.month <= 6 ? Date.new(Date.today.year, 6, 30) : Date.new(Date.today.year, 12, 31)

    (start_day..end_day).to_a.each do |day|
      if day.wday == day_of_the_week.to_i
          booking = Booking.new(
          pitch_id: pitch.id,
          start_time: day + start_time.minutes,
          end_time: day + end_time.minutes,
          user_id: pitch.user.id,
          date: day.to_date,
          player_name: player_name,
          player_phone: player_phone,
          monthly_player_id: self.id
        )
        unless booking.valid?
          errors.add(:start_time, "Existe uma reserva no dia #{day}, às #{(start_time / 60).hours}")
          break
        end
      end
    end
  end
end
