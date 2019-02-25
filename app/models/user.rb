class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable

  mount_uploader :photo, PhotoUploader

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :pitches
  has_many :bookings

  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :phone, presence: true
end
