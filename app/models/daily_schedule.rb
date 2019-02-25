class DailySchedule < ApplicationRecord
  belongs_to :pitch

  validates :pitch, presence: true

  validates :time_slot, presence: true
end
