class Booking < ApplicationRecord
  belongs_to :pitch
  belongs_to :user

  validates :pitch, presence: true
  validates :user, presence: true

  validates :start_time, presence: true
  validates :end_time, presence: true

  validate :check_end_time_greater_start_time
  validate :check_availability

  def check_end_time_greater_start_time
    if start_time > end_time
      errors.add(:start_time, "start_time can't be greater than end_time")
    end
  end

  def check_availability
    raise
  end
end
