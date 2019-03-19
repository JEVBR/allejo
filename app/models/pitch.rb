class Pitch < ApplicationRecord
  mount_uploader :photo, PhotoUploader
  geocoded_by :address

  belongs_to :user
  belongs_to :category

  has_many :bookings, dependent: :destroy

  validates :category, presence: true
  validates :user, presence: true

  validates :company, presence: true
  validates :title, presence: true

  validates :address, presence: true
  validates :cep, presence: true
  validates :cnpj, presence: true
  validates :price, presence: true

  validates :opening_time, presence: true
  validates :opening_time, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  validates :closing_time, presence: true
  validates :closing_time, numericality: { only_integer: true, less_than_or_equal_to: 24 }

  after_validation :geocode, if: :will_save_change_to_address?

  after_destroy do
    if user.pitches.empty?
      user.owner = false
      user.save
    end
  end

  after_create do
    user.owner = true
    user.save
  end
end
