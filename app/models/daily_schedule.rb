class DailySchedule < ApplicationRecord
  belongs_to :pitch

  validates :time_slot, presence: true
end
