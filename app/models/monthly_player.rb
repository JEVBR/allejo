class MonthlyPlayer < ApplicationRecord
  belongs_to :pitch

  validates :start_time, presence: true
  validates :end_time, presence: true
  validates :player_name, presence: true
  validates :player_phone, presence: true
  validates :player_email, presence: true
end
