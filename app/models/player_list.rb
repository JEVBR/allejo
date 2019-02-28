class PlayerList < ApplicationRecord
  belongs_to :booking
  belongs_to :user

  validates :booking_id, presence: true
  validates_uniqueness_of :user_id, scope: :booking_id
end
