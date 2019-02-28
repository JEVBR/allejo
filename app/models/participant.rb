class Participant < ApplicationRecord
  belongs_to :user
  belongs_to :booking

  validates :booking_id, presence: true
  validates_uniqueness_of :user_id, scope: :booking_id
end
