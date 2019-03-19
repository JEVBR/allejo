class Pitch < ApplicationRecord
  mount_uploader :photo, PhotoUploader
  geocoded_by :address

  belongs_to :user
  belongs_to :category

  has_many :bookings, dependent: :destroy

  validates :category, presence: true
  validates :user, presence: true

  validates :company, presence: true
  validates :subtitle, presence: true

  validates :address, presence: true
  validates :cep, presence: true
  validates :cnpj, presence: true
  validates :price, presence: true

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
