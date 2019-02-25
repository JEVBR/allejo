class Booking < ApplicationRecord
  belongs_to :pitch
  belongs_to :user

  validates :pitch, presence: true
  validates :user, presence: true

  validates :start_time, presence: true
  validates :end_time, presence: true
  validates :date, presence: true
end
